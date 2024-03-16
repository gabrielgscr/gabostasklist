import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gabos_task_list/tools/constants.dart';

class LocalNotificationHelper{
  static Future<void> requestLocalNotificationPermission() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  static Future<void> initializeLocalNotifications() async {
        // Paso 1: Inicializa el plugin.
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = const AndroidInitializationSettings('launcher_icon');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, 
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  static void showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data,
  }) {
      
    const androidDetails = AndroidNotificationDetails(
      remindersChannelId, 
      remindersChannelName,
      channelDescription: channelDescription,
      playSound: true,
      //sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      //TODO IOS
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails, payload: data );
  }

  static void onDidReceiveNotificationResponse( NotificationResponse response ) {
    //TODO
  }

}