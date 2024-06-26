import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notifs_app/firebase_options.dart';

import '../../../domain/entities/push_message.dart';

part 'notification_event.dart';
part 'notification_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  print('Handling a bg message: ${message.messageId}');
}
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  int pushNumberId = 0;

  final Future<void> Function()? requestLocalNotificationPermissions;
  final void Function({
        required int id,
        String? title,
        String? body,
        String? data,
    })? showLocalNotification;

  NotificationBloc({
      this.showLocalNotification,
      this.requestLocalNotificationPermissions
  }) : super(const NotificationState() ){
    on<NotificationsStatusChanged>(_notificationStatusChanged);
    on<NotificationReceived>(_onPushMessageReceived);

    // verificar estado de notificaciones
    _initialStatusCheck();

    // listener de notifs en 2ndonplano
    _onForegroundMessage();
  }


  static Future<void> initializeFCM () async {
    await Firebase.initializeApp(
      options : DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationStatusChanged(NotificationsStatusChanged event, Emitter<NotificationState> emit){
    emit(
      state.copyWith(
        status: event.status
      )
    );
    _getFCMToken();
  }
  
  void _onPushMessageReceived(NotificationReceived event, Emitter<NotificationState> emit){
    emit(
      state.copyWith(
        notifications: [event.pushMessage, ...state.notifications]
      )
    ); 
  }

  void _initialStatusCheck() async{
    // para saber el estado de las notificaciones
    final settings = await messaging.getNotificationSettings();
    add( NotificationsStatusChanged(settings.authorizationStatus) );
  }

  void _getFCMToken() async{
    // para obtener el token si estamoa autorizados para notifs
    // final settings = await messaging.getNotificationSettings();
    if ( state.status != AuthorizationStatus.authorized ) return;
    final token = await messaging.getToken();
    print(token);
  }

  void handleRemoteMessage(RemoteMessage message) {
    if(message.notification == null) return;
    final notification = PushMessage(
      messageId: message.messageId
      ?.replaceAll(':', '').replaceAll('%', '') 
      ?? '', 
      title: message.notification!.title ?? '', 
      body: message.notification!.body ?? '', 
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
      ? message.notification!.android?.imageUrl 
      : message.notification!.apple?.imageUrl 
      );
      if(showLocalNotification != null){
      showLocalNotification!(
        id: ++pushNumberId,
        body: notification.body,
        data: notification.messageId,
        title: notification.title
        );
      }
      print(notification);
      add(NotificationReceived(notification));

  }

  void _onForegroundMessage(){
    FirebaseMessaging.onMessage.listen(handleRemoteMessage); 
  }

  void requestPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
      );

      // solicitar permiso para las local notifs
      if(requestLocalNotificationPermissions != null){
        await requestLocalNotificationPermissions!();
        // await LocalNotifications.requestPermissionLocalNotification();
      }
      add(NotificationsStatusChanged(settings.authorizationStatus));
  }

  PushMessage? getMessageById(String pushMessageId){
    final exist = state.notifications.any((element) => element.messageId == pushMessageId);
    if (!exist) return null;
    return state.notifications.firstWhere((element) => element.messageId == pushMessageId);
  }
}

