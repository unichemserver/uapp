import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/assets.dart';
import 'package:uapp/models/user.dart';

class Utils {
  static List<String> allowedPosisi = ['JB001', 'JB002', 'JB009'];
  static String formatCurrency(String value) {
    return 'Rp${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  static bool isMarketing() {
    final box = Hive.box(HiveKeys.appBox);
    final user = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    final bagian = user.department;
    return bagian == 'MKT' || user.nama == "MICKAEL RENALDY";
  }

  static Uint8List? fotoKaryawan() {
    final box = Hive.box(HiveKeys.appBox);
    var foto = box.get(HiveKeys.fotoKaryawan);
    return foto;
  }

  static String getBaseUrl() {
    final box = Hive.box(HiveKeys.appBox);
    return box.get(HiveKeys.baseURL);
  }

  static String getEDSUrl() {
    String baseUrl = getBaseUrl();
    baseUrl = baseUrl.replaceAll('/api/index.php', '');
    return '$baseUrl/EDS';
  }

  static String getSybaseUrl() {
    String instance = getBaseUrl();
    bool isUnichem = instance.contains('unichem');
    String domain = isUnichem ? 'unichem.co.id' : 'unifood.id';
    String baseUrl = 'https://sybase.$domain/sybase/';
    return baseUrl;
  }

  static void saveFotoKaryawan(Uint8List foto) {
    final box = Hive.box(HiveKeys.appBox);
    box.put(HiveKeys.fotoKaryawan, foto);
  }

  static User getUserData() {
    final box = Hive.box(HiveKeys.appBox);
    return User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
  }

  static String getFormattedLogFileName(bool isToday) {
    final now = DateTime.now();
    if (!isToday) {
      now.subtract(const Duration(days: 1));
    }
    final dateFormatted = DateFormat('ddMMyyyy').format(now);
    return 'MOBILEPOS_$dateFormatted.txt';
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Center(
            child: LottieBuilder.asset(Assets.loadingAnimation),
          ),
        );
      },
    );
  }

  static void showDialogNotAllowed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('Warning'),
            content: const Text(
              'Anda menggunakan lokasi palsu, silahkan matikan lokasi palsu',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  openAppSettings();
                },
                child: const Text('Buka Pengaturan'),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<String?> saveSignature(Future<ByteData?> imageData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final image = await imageData;
      final pngBytes = image?.buffer.asUint8List();
      final now = DateTime.now().millisecondsSinceEpoch;
      final path = '${directory.path}/signature_$now.png';
      final file = File(path);
      await file.writeAsBytes(pngBytes!);
      return path;
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  static Future<bool> isInternetAvailable() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }

  static Future<bool> isUseMockLocation() async {
    var isMock = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        .then((value) => value.isMocked);
    return isMock;
  }

  static String getNik() {
    final box = Hive.box(HiveKeys.appBox);
    final user = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    return user.id;
  }

  static void _showSnackBar(BuildContext context, String title, String message,
      Color backgroundColor) {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    _showSnackBar(context, 'Berhasil', message, Colors.green);
  }

  static void showSnackbar(BuildContext context, String message) {
    _showSnackBar(context, 'Info', message, Colors.blue);
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    _showSnackBar(context, 'Gagal', message, Colors.red);
  }

  static void showInAppNotif(String title, String message) {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      snackStyle: SnackStyle.FLOATING,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      titleText: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      backgroundGradient: const LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  static String? generateBase64Image(ByteData byteData) {
    try {
      String starterFormat = 'data:image/png;base64,';
      List<int> pngBytes = byteData.buffer.asUint8List();
      String base64Image = base64Encode(pngBytes);
      return starterFormat + base64Image;
    } catch (e) {
      return null;
    }
  }

  static ByteData generateByteData(String base64Image) {
    try {
      String base64ImageWithoutStarter = base64Image.split(',').last;
      List<int> pngBytes = base64Decode(base64ImageWithoutStarter);
      return ByteData.view(Uint8List.fromList(pngBytes).buffer);
    } catch (e) {
      return ByteData(0);
    }
  }

  static Future<String?> pickImageFile() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowCompression: true,
      );
      if (result != null) {
        return result.files.single.path;
      }
    }
    return null;
  }
}
