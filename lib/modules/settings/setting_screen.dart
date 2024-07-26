import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/utils/assets.dart';
import 'package:uapp/core/widget/webview_widget.dart';
import 'package:uapp/modules/settings/setting_controller.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      init: SettingController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Pengaturan',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SwitchListTile(
                value: ctx.isNotificationEnabled,
                title: const Row(
                  children: [
                    Icon(Icons.notifications),
                    SizedBox(width: 16),
                    Text('Notifikasi'),
                  ],
                ),
                onChanged: (value) {
                  if (value) {
                    ctx.requestNotificationPermission();
                  } else {
                    ctx.cancelNotificationPermission();
                    Get.snackbar(
                      'Notifikasi',
                      'Izin menampilkan notifikasi telah diberikan',
                    );
                  }
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Kebijakan Privasi'),
                leading: const Icon(Icons.privacy_tip),
                onTap: () {
                  Get.to(() => const AuthWebviewWidget(
                    url:
                    'https://unichem.co.id/uapp/privacy_policy.html',
                    title: 'Kebijakan Privasi U-APP',
                  ));
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Syarat dan Ketentuan'),
                leading: const Icon(Icons.article),
                onTap: () {
                  Get.to(() => const AuthWebviewWidget(
                    url:
                    'https://unichem.co.id/uapp/term_of_use.html',
                    title: 'Syarat Penggunaan U-APP',
                  ));
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Tentang Aplikasi'),
                leading: const Icon(Icons.info),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'U-APP',
                    applicationVersion: '1.0.0',
                    applicationIcon: Image.asset(Assets.iconApp),
                    children: [
                      const Text('Aplikasi ini dibuat oleh UApp Team'),
                    ],
                  );
                },
              ),
              const Divider(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('© 2024 UApp Team'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
