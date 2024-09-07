import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfo {
  static Future<BaseDeviceInfo> initialize(DeviceInfoPlugin plugin) {
    if (kIsWeb) {
      return plugin.webBrowserInfo;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return plugin.androidInfo;
      case TargetPlatform.iOS:
        return plugin.iosInfo;
      case TargetPlatform.macOS:
        return plugin.macOsInfo;
      case TargetPlatform.windows:
        return plugin.windowsInfo;
      case TargetPlatform.linux:
        return plugin.linuxInfo;
      case TargetPlatform.fuchsia:
        throw UnimplementedError('Fuchsia is not supported');
    }
  }

  static bool isPhysicalDeviceWithCamera(BaseDeviceInfo deviceInfo) {
    if (deviceInfo is! IosDeviceInfo && deviceInfo is! AndroidDeviceInfo) {
      return false;
    }
    if (deviceInfo is IosDeviceInfo && deviceInfo.isPhysicalDevice) {
      return true;
    }
    if (deviceInfo is AndroidDeviceInfo && deviceInfo.isPhysicalDevice) {
      return true;
    }
    return false;
  }
}
