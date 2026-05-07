import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:gabos_task_list/tools/constants.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

class LocalNotificationHelper {
  static const int debugNotificationBaseId = 909090;
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static String? _timeZone;
  static tz.Location? _location;
  static final RxList<String> logs = <String>[].obs;
  static Completer<void>? _permissionRequestCompleter;
  static bool _permissionsRequestedOnce = false;

  static int _normalizeNotificationId(int id) {
    return (id % 100000).abs() + 1000;
  }

  static void _log(String message) {
    final entry = '[${DateTime.now().toIso8601String()}] $message';
    logs.add(entry);
    if (logs.length > 200) {
      logs.removeRange(0, logs.length - 200);
    }
    debugPrint(entry);
  }

  static Future<void> requestLocalNotificationPermission() async {
    if (_permissionsRequestedOnce) {
      return;
    }

    if (_permissionRequestCompleter != null) {
      _log('[Notif] Esperando solicitud de permisos en progreso');
      await _permissionRequestCompleter!.future;
      return;
    }

    _permissionRequestCompleter = Completer<void>();

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    try {
      if (android != null) {
        final granted = await android.requestNotificationsPermission();
        final exactGranted = await android.requestExactAlarmsPermission();
        _log('[Notif] Android permiso notificaciones: $granted');
        _log('[Notif] Android permiso exact alarms: $exactGranted');
      }

      if (ios != null) {
        final iosGranted = await ios.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        _log('[Notif] iOS permiso notificaciones: $iosGranted');
      }

      _permissionsRequestedOnce = true;
    } finally {
      _permissionRequestCompleter?.complete();
      _permissionRequestCompleter = null;
    }
  }

  static Future<void> initializeLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveBackgroundNotificationResponse,
    );

    try {
      final currentTimezone = await FlutterTimezone.getLocalTimezone();
      _timeZone = currentTimezone.identifier;
      _location = tz.getLocation(_timeZone!);
      tz.setLocalLocation(_location!);
      _log('[Notif] TimeZone: $_timeZone');
    } catch (e) {
      _log('[Notif] Error TZ: $e');
      _timeZone = null;
      _location = tz.local;
    }
  }

  @pragma('vm:entry-point')
  static void _onDidReceiveBackgroundNotificationResponse(
    NotificationResponse response,
  ) {
    _log('[Notif] Tap background payload=${response.payload}');
  }

  static void _onDidReceiveNotificationResponse(NotificationResponse response) {
    _log('[Notif] Tap foreground payload=${response.payload}');
  }

  static Future<bool> showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data,
  }) async {
    final safeId = _normalizeNotificationId(id);
    _log('[Notif] Show immediate: safeId=$safeId original=$id');
    try {
      await _plugin.show(
        safeId,
        title ?? 'Recordatorio',
        body ?? '',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            remindersChannelId,
            remindersChannelName,
            channelDescription: channelDescription,
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: data ?? id.toString(),
      );
      return true;
    } catch (e) {
      _log('[Notif] Error show immediate: $e');
      return false;
    }
  }

  static Future<Map<String, bool>> getPermissionStatus() async {
    bool notifications = true;
    bool exactAlarms = true;

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (android != null) {
      notifications = await android.areNotificationsEnabled() ?? notifications;
      exactAlarms =
          await android.canScheduleExactNotifications() ?? exactAlarms;
    }

    return {'Notificaciones': notifications, 'Alarmas exactas': exactAlarms};
  }

  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return _plugin.pendingNotificationRequests();
  }

  static NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        remindersChannelId,
        remindersChannelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static AndroidScheduleMode _scheduleMode(bool preciseAllowed) {
    return preciseAllowed
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  static Future<bool> _schedule(
    int safeId,
    DateTime scheduleDate,
    String title,
    String body,
    String payload,
    bool preciseAllowed,
    bool withTimezone,
  ) async {
    final location = withTimezone ? (_location ?? tz.local) : tz.local;
    final scheduled = tz.TZDateTime.from(scheduleDate, location);

    await _plugin.zonedSchedule(
      safeId,
      title,
      body,
      scheduled,
      _notificationDetails(),
      androidScheduleMode: _scheduleMode(preciseAllowed),
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    return true;
  }

  static Future<bool> _canUsePreciseAlarms() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) {
      return true;
    }
    return await android.canScheduleExactNotifications() ?? true;
  }

  static Future<bool> scheduleLocalNotification({
    required int id,
    required DateTime dateTime,
    String? title,
    String? body,
    String? data,
  }) async {
    try {
      await requestLocalNotificationPermission();

      final DateTime now = DateTime.now();
      final DateTime scheduleDate = dateTime.toLocal();

      if (!scheduleDate.isAfter(now)) {
        _log(
          'Recordatorio en pasado para id $id (${scheduleDate.toIso8601String()}); se envia inmediato.',
        );
        return showLocalNotification(
          id: id,
          title: title,
          body: body,
          data: data,
        );
      }

      _log(
        '[Notif] Schedule: id=$id, fecha=${scheduleDate.toIso8601String()}, tz=$_timeZone, y=${scheduleDate.year}, m=${scheduleDate.month}, d=${scheduleDate.day}, h=${scheduleDate.hour}, min=${scheduleDate.minute}',
      );

      final bool preciseAllowed = await _canUsePreciseAlarms();
      final safeId = _normalizeNotificationId(id);
      final payload = data ?? id.toString();
      _log('[Notif] Using safe ID: $safeId (original: $id)');

      bool result;
      try {
        result = await _schedule(
          safeId,
          scheduleDate,
          title ?? 'Recordatorio',
          body ?? '',
          payload,
          preciseAllowed,
          true,
        );
      } catch (e) {
        _log('[Notif] Primer intento lanzó excepción: $e');
        result = false;
      }

      if (!result) {
        _log('[Notif] Reintentando sin timezone y preciseAlarm=false');
        try {
          result = await _schedule(
            safeId,
            scheduleDate,
            title ?? 'Recordatorio',
            body ?? '',
            payload,
            false,
            false,
          );
        } catch (e) {
          _log('[Notif] Segundo intento falló: $e');
          result = false;
        }
      }

      _log('[Notif] Result: $result');
      return result;
    } catch (e) {
      _log('[Notif] Error: $e');
      return false;
    }
  }

  static Future<bool> scheduleDebugNotificationInMinutes({
    int minutes = 2,
  }) async {
    final when = DateTime.now().add(Duration(minutes: minutes));
    _log('[Notif][Debug] Programando prueba para ${when.toIso8601String()}');
    return scheduleLocalNotification(
      id: debugNotificationBaseId,
      dateTime: when,
      title: 'Prueba de notificación',
      body: 'Si ves esto, la calendarización funciona.',
      data: 'debug_test',
    );
  }

  static Future<void> cancelDebugNotification() async {
    final safeId = _normalizeNotificationId(debugNotificationBaseId);
    await _plugin.cancel(safeId);
    _log('[Notif][Debug] Cancelada notificación de prueba id=$safeId');
  }

  static Future<void> cancelLocalNotification(int id) async {
    final safeId = _normalizeNotificationId(id);
    await _plugin.cancel(safeId);
    _log('[Notif] Cancelada notificación id=$safeId (original: $id)');
  }
}
