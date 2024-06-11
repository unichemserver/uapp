import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uapp/modules/report/report_controller.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(
      init: ReportController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Report'),
          ),
          body: ctx.cameras == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    GestureDetector(
                      onTapUp: (details) {
                        final x = details.localPosition.dx;
                        final y = details.localPosition.dy;
                        final width = MediaQuery.of(context).size.width;
                        final height = MediaQuery.of(context).size.height;
                        final cameraHeight = height - ctx.cameraController.value.aspectRatio;
                        double xp = x / width;
                        double yp = y / cameraHeight;
                        Offset position = Offset(xp, yp);
                        ctx.cameraController.setFocusPoint(position);
                      },
                      child: CameraPreview(
                        ctx.cameraController,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.switch_camera_outlined),
                              iconSize: 50,
                              onPressed: ctx.switchCamera,
                            ),
                            IconButton(
                              icon: const Icon(Icons.camera),
                              iconSize: 70,
                              onPressed: () async {
                                Get.dialog(
                                  const PopScope(
                                    canPop: false,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  barrierDismissible: false,
                                );
                                final image =
                                    await ctx.cameraController.takePicture();
                                Get.back();
                                Get.back(result: image.path);
                              },
                            ),
                            IconButton(
                              iconSize: 50,
                              icon: Icon(
                                ctx.isFlashOn
                                    ? Icons.flash_on
                                    : Icons.flash_off,
                              ),
                              onPressed: ctx.toggleFlash,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
