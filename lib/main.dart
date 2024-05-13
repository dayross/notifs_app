import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifs_app/config/router/app_router.dart';
import 'package:notifs_app/config/theme/app_theme.dart';
import 'package:notifs_app/presentantion/blocs/notifications/notification_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationBloc.initializeFCM(); 
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NotificationBloc(),
        ),
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
    );
  }
}

