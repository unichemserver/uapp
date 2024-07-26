import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/modules/chat/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: ChatController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chat'),
          ),
          body: const Center(
            child: Text('Tahap Pengembangan'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ctx.getContact();
              Get.toNamed(Routes.CONTACT);
            },
            child: const Icon(Icons.contacts),
          )
        );
      }
    );
  }
}