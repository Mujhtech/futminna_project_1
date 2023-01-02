import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Commons {
  static const primaryColor = Color(0xFF800F80);
  static const whiteColor = Color(0xFFFFFFFF);
  static const String sharedPrefCartListKey = 'SharedData';
  static const String emptyJsonStringData = '{"data": []}';

  static Future<bool> checkCameraPermission() async {
    final result = await Permission.camera.status;
    if (result.isDenied) {
      return false;
    } else if (result.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> requestCameraPermission() async {
    final result = await [Permission.camera].request();
    if (result[Permission.camera]!.isDenied) {
      return false;
    } else if (result[Permission.camera]!.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> checkStoragePermission() async {
    final result = await Permission.storage.status;
    if (result.isDenied) {
      return false;
    } else if (result.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> requestStoragePermission() async {
    final result = await [Permission.storage].request();
    if (result[Permission.storage]!.isDenied) {
      return false;
    } else if (result[Permission.storage]!.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
