import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';

class CheckInPage extends StatelessWidget {
  CheckInPage({super.key});

  String imagePath = '';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketingController>(
      init: MarketingController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Check in - Kunjungan',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Foto Check In',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Rubik',
                      ),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: imagePath.isEmpty
                      ? GestureDetector(
                          onTap: () async {
                            var result = await Get.toNamed(Routes.REPORT);
                            if (result != null) {
                              imagePath = result as String;
                              ctx.update();
                            }
                          },
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.grey,
                                  size: 48,
                                ),
                                Text(
                                  'Upload Foto',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Colors.grey,
                                        fontFamily: 'Rubik',
                                      ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            Get.dialog(
                              AlertDialog(
                                content: Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text('Tutup'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      imagePath = '';
                                      ctx.update();
                                      Get.back();
                                    },
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Lokasi Check In',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Rubik',
                      ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    ctx.userAddress!.split('*')[0],
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontFamily: 'Rubik',
                        ),
                  ),
                  subtitle: Text(
                    ctx.userAddress!.split('*')[1],
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontFamily: 'Rubik',
                        ),
                  ),
                  leading: const Icon(Icons.location_on),
                  trailing: IconButton(
                    onPressed: ctx.getUserPosition,
                    icon: const Icon(Icons.my_location),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (imagePath.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Upload foto terlebih dahulu',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => LoadingDialog(),
                      );
                      await ctx.checkIn(imagePath);
                      Get.back();
                      ctx.changeIndex(2);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text(
                    'Check In',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
