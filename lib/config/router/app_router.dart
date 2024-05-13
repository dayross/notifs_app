

import 'package:go_router/go_router.dart';
import 'package:notifs_app/presentantion/screens/home_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    )
  ]
);