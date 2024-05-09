part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final AuthorizationStatus status ;
  // TODO crear modelo de notifs
  final List<dynamic> notifications;

  const NotificationState({
    this.status = AuthorizationStatus.notDetermined,
    this.notifications = const[]
    });
  
  NotificationState copyWith({
    AuthorizationStatus? status,
    List<dynamic>? notification
  }) => NotificationState(
    notifications: notifications ?? this.notifications, 
    status: status ?? this.status
    );

  @override
  List<Object> get props => [status, notifications];
}


