import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLicenseKey(String licenseKey) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('LICENSE_KEY', licenseKey);
}

Future<String?> getLicenseKey() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('LICENSE_KEY');
}
