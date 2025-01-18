import 'dart:async';
import 'package:device_apps/device_apps.dart';
import 'package:geolocator/geolocator.dart';

class FakeGpsChecker {

  static const List<String> fakeGpsPackages = [
    'com.just4fun.fake.gps.professional',
    'com.theappninjas.fakegpsjoystick',
    'com.incorporateapps.fakegps.fre',
    'com.pe.fakegps',
    'com.rosteam.gpsemulator',
    'com.fakegps.location.floater',
    'com.gsmartstudio.fakegps',
    'com.lexa.fakegps',
  ];

  static Future<bool> isFakeGpsInstalled() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeSystemApps: false,
      includeAppIcons: false,
    );

    for (var app in apps) {
      print('Checking app: ${app.packageName}');
      if (fakeGpsPackages.contains(app.packageName)) {
        return true;
      }
    }
    return false;
  }

  static Future<bool> isMockLocationEnabled() async {
    try {
      final Position position = await Geolocator.getCurrentPosition();
      return position.isMocked;
    } catch (e) {
      print('Error checking mock location: $e');
      return false;
    }
  }
}
