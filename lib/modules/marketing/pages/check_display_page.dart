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
      builder: (ctx) {
        return Scaffold(
          appBar: _buildAppBar(),
          floatingActionButton: _buildFloatingActionButton(ctx),
          body: _buildBody(context, ctx),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Cek Display',
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: const SizedBox(),
    );
  }

  FloatingActionButton _buildFloatingActionButton(MarketingController ctx) {
    return FloatingActionButton(
      onPressed: () {
        Get.toNamed(Routes.REPORT)!.then((value) {
          if (value != null) {
            ctx.addDisplayToDatabase(value);
          }
        });
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _buildBody(BuildContext context, MarketingController ctx) {
    return ctx.displayList.isEmpty
        ? _buildEmptyState(context)
        : _buildDisplayList(ctx);
  }

  Widget _buildEmptyState(BuildContext context) {
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
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayList(MarketingController ctx) {
    return ListView.builder(
      itemCount: ctx.displayList.length,
      itemBuilder: (context, index) {
        return _buildDisplayItem(context, ctx, ctx.displayList[index]);
      },
    );
  }

  Widget _buildDisplayItem(
    BuildContext context,
    MarketingController ctx,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () => _showImageDialog(context, ctx, imagePath),
      child: Dismissible(
        key: Key(imagePath),
        background: _buildDeleteBackground(),
        confirmDismiss: (direction) {
          ctx.deleteDisplayFromDatabase(imagePath);
          return Future.value(true);
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: FileImage(File(imagePath)),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.bottomRight,
          // child: _buildDeleteButton(ctx, imagePath),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(MarketingController ctx, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: const Icon(Icons.delete, color: Colors.white),
        onPressed: () {
          ctx.deleteDisplayFromDatabase(imagePath);
        },
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      color: Colors.red,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.delete, color: Colors.white),
          SizedBox(width: 8.0),
        ],
      ),
    );
  }

  void _showImageDialog(
    BuildContext context,
    MarketingController ctx,
    String imagePath,
  ) {
    Get.dialog(
      Image.file(File(imagePath)),
    );
  }
}
