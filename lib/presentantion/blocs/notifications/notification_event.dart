part of 'notification_bloc.dart';

sealed class NotificationEvent {
  const NotificationEvent();
}

class NotificationsStatusChanged extends NotificationEvent{
  final AuthorizationStatus status;
  NotificationsStatusChanged(this.status);
}
