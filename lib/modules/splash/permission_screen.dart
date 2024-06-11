import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/hive/hive_keys.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  final ValueNotifier<PermissionStatus> _cameraStatus =
      ValueNotifier(PermissionStatus.denied);
  final ValueNotifier<PermissionStatus> _locationStatus =
      ValueNotifier(PermissionStatus.denied);
  final ValueNotifier<PermissionStatus> _microphoneStatus =
      ValueNotifier(PermissionStatus.denied);
  final ValueNotifier<PermissionStatus> _bluetoothScanStatus =
      ValueNotifier(PermissionStatus.denied);

  Future<void> _requestPermissions() async {
    final cameraPermission = await Permission.camera.request();
    setState(() {
      _cameraStatus.value = cameraPermission;
    });
    final microphonePermission = await Permission.microphone.request();
    setState(() {
      _microphoneStatus.value = microphonePermission;
    });
    final locationPermission = await Permission.locationWhenInUse.request();
    setState(() {
      _locationStatus.value = locationPermission;
    });
    final bluetoothScanPermission = await Permission.bluetoothScan.request();
    setState(() {
      _bluetoothScanStatus.value = bluetoothScanPermission;
    });

    final box = Hive.box(HiveKeys.appBox);
    box.put(HiveKeys.isFirstTime, false);
    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamed(Routes.AUTH);
    });
  }

  _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Izin Penggunaan'),
          content: const Text(
            'Aplikasi memerlukan izin penggunaan kamera, lokasi, dan mikrofon.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _requestPermissions();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Izin Penggunaan',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ListTile(
                onTap: () async {
                  var cameraStatus = await Permission.camera.request();
                  setState(() {
                    _cameraStatus.value = cameraStatus;
                  });
                },
                title: const Text('Camera'),
                leading: const Icon(Icons.camera),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Status: "),
                    Text(
                      _cameraStatus.value == PermissionStatus.granted
                          ? 'Disetujui'
                          : 'Ditolak',
                      style: TextStyle(
                        color: _cameraStatus.value.isGranted
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: () async {
                  var micStatus = await Permission.microphone.request();
                  setState(() {
                    _microphoneStatus.value = micStatus;
                  });
                },
                title: const Text('Microphone'),
                leading: const Icon(Icons.mic),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Status: "),
                    Text(
                      _microphoneStatus.value == PermissionStatus.granted
                          ? 'Disetujui'
                          : 'Ditolak',
                      style: TextStyle(
                        color: _microphoneStatus.value.isGranted
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: () async {
                  var locationStatus =
                      await Permission.locationWhenInUse.request();
                  setState(() {
                    _locationStatus.value = locationStatus;
                  });
                },
                title: const Text('Location'),
                leading: const Icon(Icons.location_on),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Status: "),
                    Text(
                      _locationStatus.value == PermissionStatus.granted
                          ? 'Disetujui'
                          : 'Ditolak',
                      style: TextStyle(
                        color: _locationStatus.value.isGranted
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: () async {
                  var bluetoothStatus =
                      await Permission.bluetoothScan.request();
                  setState(() {
                    _bluetoothScanStatus.value = bluetoothStatus;
                  });
                },
                title: const Text('Bluetooth'),
                leading: const Icon(Icons.bluetooth),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Status: "),
                    Text(
                      _bluetoothScanStatus.value == PermissionStatus.granted
                          ? 'Disetujui'
                          : 'Ditolak',
                      style: TextStyle(
                        color: _bluetoothScanStatus.value.isGranted
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Jika semua izin disetujui, maka akan melanjutkan ke halaman berikutnya',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
