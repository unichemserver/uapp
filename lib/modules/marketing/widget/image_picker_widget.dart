import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';

class ImagePickerWidget extends StatelessWidget {
  final String imagePath;
  final Function(String) onImagePicked;
  final Function() onImageRemoved;

  const ImagePickerWidget({
    Key? key,
    required this.imagePath,
    required this.onImagePicked,
    required this.onImageRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(16),
      ),
      child: GestureDetector(
        onTap: () async {
          if (imagePath.isNotEmpty) {
            Get.dialog(
              Dialog.fullscreen(
                child: InteractiveViewer(
                  child: Image.file(
                    File(imagePath),
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          } else {
            Get.dialog(
              AlertDialog(
                title: const Text('Pilih Sumber Gambar'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('Kamera'),
                      leading: const Icon(Icons.camera_alt),
                      onTap: () async {
                        var img = await Get.toNamed(Routes.REPORT);
                        if (img != null) {
                          onImagePicked(img as String);
                          Get.back();
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('Galeri'),
                      leading: const Icon(Icons.image),
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.image,
                        );
                        if (result != null) {
                          onImagePicked(result.files.single.path!);
                          Get.back();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
        child: imagePath.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo),
                    Text('Upload Foto'),
                  ],
                ),
              )
            : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(imagePath),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      onPressed: onImageRemoved,
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
