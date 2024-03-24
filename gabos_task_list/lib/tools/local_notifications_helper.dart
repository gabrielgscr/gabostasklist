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
      null,
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

  static void scheduleLocalNotification({
    required int id,
    required DateTime dateTime,
    String? title,
    String? body,
    String? data,
  }) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: remindersChannelId,
        title: title,
        body: body,
        payload: {'id':id.toString()},
      ),
      schedule: NotificationCalendar.fromDate(date: dateTime),
    );
  }

}