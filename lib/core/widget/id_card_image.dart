import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

class IdCard extends StatefulWidget {
  final String name;
  final String jobTitle;
  final Uint8List photoUrl;
  final String qrUrl;
  final String nik;
  final String department;

  const IdCard({
    super.key,
    required this.name,
    required this.jobTitle,
    required this.photoUrl,
    required this.qrUrl,
    required this.nik,
    required this.department,
  });

  @override
  State<IdCard> createState() => _IdCardState();
}

class _IdCardState extends State<IdCard> {
  double? _previousBrightness;

  @override
  void initState() {
    super.initState();
    _setMaxBrightness();
  }

  @override
  void dispose() {
    _restorePreviousBrightness();
    super.dispose();
  }

  Future<void> _setMaxBrightness() async {
    try {
      _previousBrightness = await ScreenBrightness().current;
      await ScreenBrightness().setScreenBrightness(1.0);
    } catch (e) {
      print("Error setting brightness: $e");
    }
  }

  Future<void> _restorePreviousBrightness() async {
    if (_previousBrightness != null) {
      try {
        await ScreenBrightness().setScreenBrightness(_previousBrightness!);
      } catch (e) {
        print("Error restoring brightness: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ID Card'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Image.network(
              'https://unichem.co.id/EDS/assets/images/bg-user-id-card.png',
              width: width,
              height: height,
            ),
            Positioned(
              left: 0.1 * width,
              top: widget.name.length >= 20 ? 0.32 * height : 0.38 * height,
              child: Text(
                widget.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.05,
                ),
              ),
            ),
            Positioned(
              left: 0.1 * width,
              top: 0.425 * height,
              child: Text(
                widget.jobTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.045,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: height * 0.09,
              child: Hero(
                tag: 'profile_photo',
                child: Image.memory(
                  widget.photoUrl,
                  width: width * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: width * 0.091,
              top: 0.607 * height,
              child: Image.network(
                widget.qrUrl,
                width: width / 3,
                height: width / 3,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0.45 * width,
              bottom: 0.15 * height,
              right: 0.05 * width,
              child: Text(
                'NIK: ${widget.nik}\n${widget.department}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.045,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
