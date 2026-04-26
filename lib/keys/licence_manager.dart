import 'dart:async';

import 'package:example/keys/core/infrastructure/encrypt_service.dart';
import 'package:example/screens/main_home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LicenseManager {
  // License key and expiration date stored in secure storage
  String secretKey = 'SeevaEducation@2024';
  String _licenseKey = '';
  // DateTime _expirationDate = DateTime.now();

  // Function to initialize the license manager
  Future<void> init() async {
    // final date = DateTime.now().add(const Duration(days: 365));
    // // Retrieve license key and expiration date from secure storage
    // final prefs = await SharedPreferences.getInstance();
    // _licenseKey = (prefs.getString('licenseKey')) ?? '';
    // // String? expirationDateString = prefs.getString('expirationDate');
    // // if (expirationDateString != null) {
    // //   _expirationDate = DateTime.parse(expirationDateString);
    // // }

    // String key = encryptMyData(date);
    // if (kDebugMode) {
    //   print("key: $key");
    // }
    // DateTime d = decryptMyData(key);syfElTVXSy1Kcq7yZDLnMiV7FIiGL94FYXNpS/eC9GY=
    // print("date: $d");
  }

  // Function to check if the license is valid
  bool isLicenseValid(WidgetRef ref) {
    final expiryDate = decryptMyData(_licenseKey);
    if (expiryDate == null) {
      return false;
    }
    final isValids = expiryDate.isAfter(DateTime.now());
    ref.read(isNotExpired.notifier).state = isValids;
    return isValids;
  }

  bool isValid(String text) {
    if (text.length <= 40) return false;
    bool? isb = isBase64(text);
    if (!isb) return false;

    final expiryDate = decryptMyData(text);
    return expiryDate.isAfter(DateTime.now());
  }

  // Function to validate the license
  Future<bool> validateLicense(WidgetRef ref) async {
    // Initialize license manager if not already initialized
    await init();
    // Check if license is valid
    return isLicenseValid(ref);
  }

  // Function to set the license key and expiration date
  Future<void> setLicense(String licenseKey) async {
    // Store license key and expiration date in secure storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('licenseKey', licenseKey);
    // await prefs.setString('expirationDate', expirationDate.toIso8601String());
    // Update internal license information
    _licenseKey = licenseKey;
    // _expirationDate = expirationDate;
  }
}
