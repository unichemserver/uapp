import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:uapp/core/utils/assets.dart';
import 'package:uapp/core/widget/profile_image.dart';
import 'package:uapp/modules/chat/chat_controller.dart';

class ContactPage extends StatelessWidget {
  ContactPage({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: ChatController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: searchController,
              onChanged: (value) {
                ctx.searchContact(value);
                if (value.isNotEmpty) {
                  ctx.setShowCloseButton(true);
                } else {
                  ctx.setShowCloseButton(false);
                }
              },
              decoration: InputDecoration(
                hintText: 'Cari kontak',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: ctx.showCloseButton
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          ctx.setShowCloseButton(false);
                          ctx.getContact();
                          searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
          body: ctx.contactList.isEmpty
              ? Center(child: LottieBuilder.asset(Assets.noDataAnimation))
              : ListView.builder(
                  itemCount: ctx.contactList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {},
                      leading: GestureDetector(
                        onTap: () {
                          Get.dialog(
                            ProfileImage(
                              imgUrl: ctx
                                  .getFotoNamaUrl(ctx.contactList[index].foto),
                              radius: 250.0,
                            ),
                          );
                        },
                        child: ProfileImage(
                          imgUrl:
                              ctx.getFotoNamaUrl(ctx.contactList[index].foto),
                          radius: 50.0,
                        ),
                      ),
                      title: Text(ctx.contactList[index].nickName),
                      subtitle: Text(ctx.contactList[index].name),
                      trailing: Text(ctx.contactList[index].bagian),
                    );
                  },
                ),
        );
      },
    );
  }
}
