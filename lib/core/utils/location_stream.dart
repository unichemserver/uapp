import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

class LocationPermissionStream {
  final _permissionController = StreamController<ServiceStatus>.broadcast();

  LocationPermissionStream() {
    _init();
  }

  Stream<ServiceStatus> get permissionStatusStream =>
      _permissionController.stream;

  void _init() async {
    final status = await Permission.location.serviceStatus;
    _permissionController.add(status);

    Permission.location.serviceStatus.asStream().listen((status) {
      _permissionController.add(status);
    });
  }

  void dispose() {
    _permissionController.close();
  }
}