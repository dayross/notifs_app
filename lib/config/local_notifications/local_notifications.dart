

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifs_app/config/router/app_router.dart';


class LocalNotifications{
  static Future<void> requestPermissionLocalNotification() async{
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
  .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.requestNotificationsPermission();
  }

  static Future<void> initializeLocalNotifications() async{

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initSettingsAndroid = AndroidInitializationSettings('app_icon');
    const initSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: iosShowNotification);

    const initializationSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsDarwin,
      );


    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
      // TODO
      // onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse
      );
  }

  static void iosShowNotification(int id, String? title, String? body, String? data){
    showLocalNotification(id: id, title: title, body: body, data: data);
  }

  static void showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data,
  }){
    const androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notif_tone'),
      importance: Importance.high,
      priority: Priority.high
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(
          presentSound: true
        )
      );

      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.show(
        id, 
        title,
        body, 
        notificationDetails,
        payload: data);
  }
  
  static void onDidReceiveNotificationResponse(NotificationResponse response){
    appRouter.push('/push-details/${response.payload}');
  } 

}