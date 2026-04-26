import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

String generateLicenseKey(DateTime expiryDate, String secretKey) {
  final key = encrypt.Key.fromUtf8(secretKey);
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  final plainText = expiryDate.toIso8601String();
  final encrypted = encrypter.encrypt(plainText, iv: iv);

  return encrypted.base64;
}

String getSignatureHash(
    DateTime expiryDate, String secretKeys, String publicKeys) {
  final secretKey = secretKeys;
  final publicKey = publicKeys;
  final secretKeyBytes = utf8.encode(secretKey);
  final publicKeyBytes = utf8.encode(publicKey);
  final hmacSha256 = Hmac(sha256, secretKeyBytes);
  final digest = hmacSha256.convert(publicKeyBytes);
  return digest.toString();
}

// String decryptAES(String encryptedText, String key) {
//   final aesDecoder = encrypt.AESDecryptor(key, encrypt.IV.fromLength(16));
//   final decryptedBytes = aesDecoder.convert(base64.decode(encryptedText));
//   return String.fromCharCodes(decryptedBytes);
// }

final key = encrypt.Key.fromUtf8('put32charactershereeeeeeeeeeeee!'); //32 chars
final iv = encrypt.IV.fromUtf8('put16characters!');

//encrypt
String encryptMyData(DateTime expiryDate) {
  final e = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final encryptedData = e.encrypt(expiryDate.toString(), iv: iv);
  return encryptedData.base64;
}

//dycrypt
DateTime decryptMyData(String text) {
  final e = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final decryptedData = e.decrypt(encrypt.Encrypted.fromBase64(text), iv: iv);
  return DateTime.parse(decryptedData);
  
}

bool isBase64(String text) {
  final base64Regex = RegExp(r'^[A-Za-z0-9+/=-]+$');
  return base64Regex.hasMatch(text);
}
