part of 'notification_bloc.dart';

sealed class NotificationEvent {
  const NotificationEvent();
}

class NotificationsStatusChanged extends NotificationEvent{
  final AuthorizationStatus status;
  NotificationsStatusChanged(this.status);
}

class NotificationReceived extends NotificationEvent{
  final PushMessage pushMessage;
  NotificationReceived( this.pushMessage);
}
// TODO 2: Notification received # pushmessage