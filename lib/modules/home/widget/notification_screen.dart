import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        final notifications = controller.allNotifications;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Semua Notifikasi'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 1,
          ),
          body: notifications.isEmpty
              ? const Center(child: Text('Tidak ada notifikasi'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const Divider(height: 24),
                  itemBuilder: (context, idx) {
                    final notif = notifications[idx];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        notif['title'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          notif['content'] ?? '',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      trailing: Text(
                        notif['created_at']?.toString().substring(0, 16) ?? '',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
