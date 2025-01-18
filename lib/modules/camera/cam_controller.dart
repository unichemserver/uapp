import 'package:camera/camera.dart';
import 'package:get/get.dart';

class CamController extends GetxController {
  bool isPreviewPaused = false;
  bool isFlashOn = false;
  bool isLoading = false;
  late CameraController cameraController;
  int selectedCamera = 0;
  List<CameraDescription>? cameras;

  void initCamera() async {
    cameras = await availableCameras();
    if (cameras!.isEmpty) {
      Get.snackbar(
        'Error',
        'No camera found!',
      );
      return;
    }
    cameraController = CameraController(cameras![0], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      if (isClosed) {
        return;
      }
      update();
    }).catchError((error) {
      if (error is CameraException) {
        switch (error.code) {
          case 'CameraAccessDenied':
            Get.snackbar(
              'Error',
              'The user did not grant the camera permission!',
            );
            break;
          default:
            Get.snackbar(
              'Error',
              'Error: ${error.code}\nError Message: ${error.description}',
            );
        }
      }
    });
  }

  void toggleFlash() {
    if (cameraController.value.isPreviewPaused) {
      Get.snackbar(
        'Error',
        'Cannot change the flashlight while the preview is paused.',
      );
      return;
    }

    isFlashOn = !isFlashOn;
    cameraController.setFlashMode(
      isFlashOn ? FlashMode.always : FlashMode.off,
    );
    update();

    if (isFlashOn) {
      Get.snackbar('Info', 'Flashlight is on.');
    } else {
      Get.snackbar('Info', 'Flashlight is off.');
    }
  }

  void switchCamera() {
    if (selectedCamera == 0) {
      selectedCamera = 1;
      cameraController = CameraController(cameras![1], ResolutionPreset.max);
    } else {
      selectedCamera = 0;
      cameraController = CameraController(cameras![0], ResolutionPreset.max);
    }
    cameraController.initialize().then((_) {
      if (isClosed) {
        return;
      }
      update();
    });
  }

  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
