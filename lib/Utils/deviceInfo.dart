import 'dart:io' show Platform; // Untuk contoh sederhana cross-platform
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get_utils/src/platform/platform.dart';

  Future<String> getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String device_name = "unknown device";
    try {
      if (GetPlatform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        device_name = "${androidInfo.manufacturer} ${androidInfo.model}";
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        device_name = "${iosInfo.model} ${iosInfo.name}";
      }
    } catch (e) {
      return "Error while catching device info";
    }
    return device_name;
  }