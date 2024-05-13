import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notifs_app/presentantion/blocs/notifications/notification_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.select((NotificationBloc bloc) => Text('${bloc.state.status}')),
        // title: context.select( (NotificationBloc bloc) => Text('${bloc.state.status}')),
        actions: [
          IconButton(onPressed: (){
            // read para nr
            context.read<NotificationBloc>().requestPermission();
          }, 
          icon: const Icon(Icons.settings))
        ],
      ),
      body: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationBloc>().state.notifications;
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notif = notifications[index];
        return  ListTile(
          title: Text(notif.title),
          subtitle: Text(notif.body),
          leading: notif.imageUrl != null 
          ? Image.network(notif.imageUrl!) 
          : const Icon(Icons.image_not_supported),
          onTap: (){
            context.push('/push-details/${notif.messageId}');
          },
        );
      },
    );
  }
}