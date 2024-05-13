import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notifs_app/firebase_options.dart';

import '../../../domain/entities/push_message.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationBloc() : super(const NotificationState() ){
    on<NotificationsStatusChanged>(_notificationStatusChanged);
    
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

  void _initialStatusCheck() async{
    // para saber el estado de las notificaciones
    final settings = await messaging.getNotificationSettings();
    settings.authorizationStatus;
  }

  void _getFCMToken() async{
    // para obtener el token si estamoa autorizados para notifs
    final settings = await messaging.getNotificationSettings();
    if(settings.authorizationStatus !=  AuthorizationStatus.authorized) return;
    final token = await messaging.getToken();
    print(token);
  }

  void _handleRemoteMessage(RemoteMessage message) {
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
      print(notification);
  }


  void _onForegroundMessage(){
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage); 
  }

  void requestPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
      );
      add(NotificationsStatusChanged(settings.authorizationStatus));
  }
}

