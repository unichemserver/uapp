import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/canvasing/canvasing_controller.dart';

class AddCustomerWidget extends StatelessWidget {
  const AddCustomerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CanvasingController>(
      builder: (ctx) {
        return Scaffold(
          body: Form(
            key: ctx.addFormKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: ctx.outletImagePath.isEmpty
                        ? GestureDetector(
                            onTap: () async {
                              var imgPath = await Get.toNamed(Routes.REPORT);
                              if (imgPath != null) {
                                ctx.outletImagePath = imgPath;
                                ctx.update();
                              }
                            },
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'Ambil Foto Outlet',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Stack(
                            children: [
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: Image.file(
                                            File(ctx.outletImagePath),
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(ctx.outletImagePath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      if (ctx.isToComplete) return;
                                      ctx.outletImagePath = '';
                                      ctx.update();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Nama Outlet',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                AppTextField(
                  readOnly: ctx.isToComplete,
                  prefixIcon: const Icon(Icons.store),
                  controller: ctx.namaController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama Outlet tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    ctx.namaController.text = value.toUpperCase();
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Nama Pemilik',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                AppTextField(
                  readOnly: ctx.isToComplete,
                  prefixIcon: const Icon(Icons.person),
                  controller: ctx.pemilikController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama Pemilik tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    ctx.pemilikController.text = value.toUpperCase();
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Nomor Telepon',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                AppTextField(
                  readOnly: ctx.isToComplete,
                  prefixIcon: const Icon(Icons.phone),
                  controller: ctx.telpController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'No. Telp tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Alamat',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                TextFormField(
                  readOnly: true,
                  textAlignVertical: TextAlignVertical.center,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: ctx.alamatController,
                  maxLines: null,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    prefixIcon: const Icon(Icons.location_on),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (ctx.isToComplete) return;
                        if (ctx.latitude != null && ctx.longitude != null) {
                          return;
                        }
                        ctx.setOutletAddress('Mendapatkan Lokasi...');
                        ctx.getCurrentLocation();
                      },
                      icon: const Icon(Icons.my_location),
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
