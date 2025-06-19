import 'dart:io' show Platform; // Used for Platform.isAndroid, Platform.isIOS

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../logger/app_logger.dart'; // Used for checking if it's web

Future<Map<String, dynamic>> getDeviceInfo() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};

  try {
    if (kIsWeb) {
      final WebBrowserInfo webBrowserInfo =
          await deviceInfoPlugin.webBrowserInfo;
      deviceData = _readWebBrowserInfo(webBrowserInfo);
    } else {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo =
            await deviceInfoPlugin.androidInfo;
        deviceData = _readAndroidBuildData(androidInfo);
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        deviceData = _readIosDeviceInfo(iosInfo);
      }
      // You can add more platforms like macOS, Windows, Linux if needed
    }
  } catch (e) {
    AppLogger.e('Failed to get platform info: $e');
    // Handle error, return default or empty data
    deviceData = {'Error': e.toString()};
  }

  return deviceData;
}

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'device_name':
        build.model, // Common Android "device name" is often the model
    'manufacturer': build.manufacturer,
    'model': build.model,
    'brand': build.brand,
    'os_version': build.version.release,
    'sdk_int': build.version.sdkInt,
    'device_type': 'android',
    'device_uuid': build.id,
    // You can get many more properties like:
    // 'id': build.id,
    // 'display': build.display,
    // 'hardware': build.hardware,
    // 'product': build.product,
    // 'supported_abis': build.supportedAbis,
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  // For iOS, 'name' is often the user-defined device name (e.g., "John's iPhone")
  // 'model' is the product type (e.g., "iPhone15,2")
  // 'localizedModel' is the marketing name (e.g., "iPhone 14 Pro")
  return <String, dynamic>{
    'device_name': data.name,
    'system_name': data.systemName,
    'system_version': data.systemVersion,
    'model': data.model, // E.g., iPhone15,2
    'localized_model': data.localizedModel, // E.g., iPhone 14 Pro
    'is_physical_device': data.isPhysicalDevice,
    'utsname_machine': data.utsname.machine, // Raw machine identifier
    'device_type': 'ios',
    // 'identifier_for_vendor': data.identifierForVendor, // Unique ID for app installation
  };
}

Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
  return <String, dynamic>{
    'device_name':
        data.userAgent ?? 'Unknown Web Browser', // User agent can be long
    'browser_name':
        data.browserName
            .toString()
            .split('.')
            .last, // E.g., 'chrome', 'firefox'
    'app_name': data.appName,
    'app_version': data.appVersion,
    'platform': data.platform,
    'device_type': 'web',
  };
}
