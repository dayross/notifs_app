import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifs_app/config/local_notifications/local_notifications.dart';
import 'package:notifs_app/config/router/app_router.dart';
import 'package:notifs_app/config/theme/app_theme.dart';
import 'package:notifs_app/presentantion/blocs/notifications/notification_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationBloc.initializeFCM(); 
  await LocalNotifications.initializeLocalNotifications();
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NotificationBloc(
            requestLocalNotificationPermissions: LocalNotifications.requestPermissionLocalNotification,
            showLocalNotification: LocalNotifications.showLocalNotification
          ),),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      builder: (context, child) => HandleNotifInteractions(child: child!),
    );
  }
}

class HandleNotifInteractions extends StatefulWidget {
  final Widget child; 
  const HandleNotifInteractions({super.key, required this.child});

  @override
  State<HandleNotifInteractions> createState() => HandleNotifInteractionsState();
}

class HandleNotifInteractionsState extends State<HandleNotifInteractions> {
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
  
  void _handleMessage(RemoteMessage message) {
    context.read<NotificationBloc>().handleRemoteMessage(message);
    final messageId = message.messageId?.replaceAll(':', '').replaceAll('%', '');

    appRouter.push('/push-details/$messageId');
    }
  

  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
  
}

