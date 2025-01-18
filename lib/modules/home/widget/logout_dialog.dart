import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/modules/home/home_controller.dart';

class LogoutDialog extends StatelessWidget {
  LogoutDialog({super.key});

  final Box box = Hive.box(HiveKeys.appBox);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Keluar'),
      content: const Text('Apakah anda yakin ingin keluar?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Tidak'),
        ),
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const LoadingDialog(
                  message: 'Menghapus data...',
                );
              },
            );
            Get.find<HomeController>().logout().then((value) => Get.back());
          },
          child: const Text('Ya'),
        ),
      ],
    );
  }
}
