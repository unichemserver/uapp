import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';

class CheckInPage extends StatelessWidget {
  const CheckInPage({super.key});

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
                  'Foto Check-In',
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
                  child: ctx.imagePath.isEmpty
                      ? GestureDetector(
                          onTap: () async {
                            var result = await Get.toNamed(Routes.REPORT);
                            if (result != null) {
                              ctx.imagePath = result as String;
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
                                  File(ctx.imagePath),
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
                                      ctx.imagePath = '';
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
                            File(ctx.imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Lokasi Check-In',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Rubik',
                      ),
                ),
                _buildUserLocation(ctx, context),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: ctx.userPosition == null
                      ? null
                      : () async {
                          if (ctx.imagePath.isEmpty) {
                            Utils.showErrorSnackBar(
                              context,
                              'Silahkan upload foto terlebih dahulu',
                            );
                            return;
                          }
                          Get.dialog(
                            AlertDialog(
                              title: const Text('Konfirmasi'),
                              content: const Text(
                                'Apakah anda yakin ingin melakukan check-in?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    // Utils.showLoadingDialog(context);
                                    ctx.checkIn().then((_) {
                                      // Navigator.of(context).pop();
                                    });
                                  },
                                  child: const Text('Ya'),
                                ),
                              ],
                            ),
                          );
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
                    'Check-In',
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

  ListTile _buildUserLocation(MarketingController ctx, BuildContext context) {
    String address =
        ctx.userAddress == null ? '' : ctx.userAddress!.split('*')[0];
    String region =
        ctx.userAddress == null ? '' : ctx.userAddress!.split('*')[1];
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        address.isEmpty
            ? ctx.userPosition == null
                ? 'Mencari lokasi...'
                : ctx.userPosition!.latitude.toString()
            : address,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontFamily: 'Rubik',
            ),
      ),
      subtitle: Text(
        region.isEmpty
            ? ctx.userPosition == null
                ? 'Mencari lokasi...'
                : ctx.userPosition!.longitude.toString()
            : region,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontFamily: 'Rubik',
            ),
      ),
      leading: const Icon(Icons.location_on),
      trailing: IconButton(
        onPressed: ctx.getUserPosition,
        icon: const Icon(Icons.my_location),
      ),
    );
  }
}
