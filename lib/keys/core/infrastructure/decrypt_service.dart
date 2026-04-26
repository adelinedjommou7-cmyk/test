import 'package:encrypt/encrypt.dart' as encrypt;

DateTime? decryptLicenseKey(String licenseKey, String secretKey) {
  try {
    final key = encrypt.Key.fromUtf8(secretKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decrypted = encrypter.decrypt64(licenseKey, iv: iv);
    return DateTime.parse(decrypted);
  } catch (e) {
    return null; // clé invalide ou erreur de déchiffrement
  }
}

bool isLicenseValid(String licenseKey, String secretKey) {
  final expiryDate = decryptLicenseKey(licenseKey, secretKey);
  if (expiryDate == null) {
    return false;
  }
  return expiryDate.isAfter(DateTime.now());
}
