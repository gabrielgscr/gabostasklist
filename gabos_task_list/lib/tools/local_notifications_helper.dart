import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:gabos_task_list/tools/constants.dart';

class LocalNotificationHelper{
  static Future<void> requestLocalNotificationPermission() async {
    if(!await AwesomeNotifications().isNotificationAllowed()){
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static Future<void> initializeLocalNotifications() async {
    AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/launcher_icon',
      //null,
      [
        NotificationChannel(
            channelGroupKey: channelGroupKey,
            channelKey: remindersChannelId,
            channelName: remindersChannelName,
            channelDescription: channelDescription,
            //defaultColor: Color(0xFF9D50DD),
            //ledColor: Colors.white
        )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: channelGroupKey,
            channelGroupName: channelGroupName)
      ],
      debug: true
    );   
  }

  static void showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data,
  }) {
      
    
  }

  static Future<bool> scheduleLocalNotification({
    required int id,
    required DateTime dateTime,
    String? title,
    String? body,
    String? data,
  }) async {
    return AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: generateRandomInteger(),
        channelKey: remindersChannelId,
        title: title,
        body: body,
        payload: {'id':id.toString()},
        wakeUpScreen: true,
        autoDismissible: false,
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationCalendar.fromDate(date: dateTime),
    );
  }

  static int generateRandomInteger() {
    return Random().nextInt(1 << 32); // Genera un número aleatorio entre 0 y 4.294.967.295
  }

}