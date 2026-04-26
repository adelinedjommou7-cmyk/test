// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnboardStorage {
  // final FlutterSecureStorage _storage;

  OnboardStorage();

  bool onboardSet = false;

  static const _key = 'onboard';

  Future<void> setOnboardedLocal() async {
    onboardSet = true;
    return; //_storage.write(key: _key, value: 'true');
  }

  Future<bool> readOnboardedLocal() async {
    final String? data = ''; // await _storage.read(key: _key);
    if (data == null) {
      return false;
    }
    try {
      if (data == 'true') {
        onboardSet = true;
      } else {
        onboardSet = false;
      }
      return onboardSet;
    } catch (e) {
      return onboardSet;
    }
  }

  Future<void> clearOnboardedLocal() async {
    onboardSet = false;
    // await _storage.delete(key: _key);
    return;
  }
}
