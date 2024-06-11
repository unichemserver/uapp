import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';

class CheckDisplayPage extends StatelessWidget {
  const CheckDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketingController>(
      init: MarketingController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Cek Display',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: const SizedBox(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.toNamed(Routes.REPORT)!.then((value) {
                if (value != null) {
                  ctx.addDisplay(value.toString());
                }
              });
            },
            child: const Icon(Icons.add),
          ),
          body: _buildBody(context, ctx),
        );
      },
    );
  }

  _buildBody(BuildContext context, MarketingController ctx) {
    if (ctx.displayList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory,
              size: 100.0,
            ),
            Text(
              'Belum ada foto yang anda upload',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: ctx.displayList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Get.dialog(
              AlertDialog(
                content: Image.file(File(ctx.displayList[index])),
                actions: [
                  TextButton(
                    onPressed: () {
                      ctx.removeDisplay(ctx.displayList[index]);
                      Get.back();
                    },
                    child: const Text('Hapus'),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Tutup'),
                  ),
                ],
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: FileImage(
                  File(ctx.displayList[index]),
                ),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ctx.removeDisplay(ctx.displayList[index]);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
