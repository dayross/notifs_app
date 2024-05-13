
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


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
    // TODO iOS config
    const initializationSettings = InitializationSettings(
      android: initSettingsAndroid,
      // TODO iOS config
      );


    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // TODO
      // onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse
      );
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
      
      )
  }
}