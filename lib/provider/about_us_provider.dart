import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutUsProvider extends ChangeNotifier {
  String appVersion = 'Loading...';

  Future<void> loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();

      appVersion =
          "Version ${packageInfo.version} (Build ${packageInfo.buildNumber})";
      notifyListeners();
    } catch (e) {
      appVersion = "Version info not available";
      notifyListeners();
    }
  }
}
