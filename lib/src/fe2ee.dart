import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:crypton/crypton.dart';
import 'package:encrypt/encrypt.dart' as enc;

class FE2EE {
  String selfPrivateKey;
  String publicKey;
  String aesKey;

  FE2EE(
      {required this.selfPrivateKey,
      required this.publicKey,
      required this.aesKey});

  String encrypt(String data) {
    var rsaPublicKey = utf8.decode(base64Decode(publicKey));
    var key = enc.Key.fromBase64(aesKey);
    var iv = enc.IV.fromSecureRandom(16);

    var encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

    final encrypted = encrypter.encrypt(data, iv: iv);
    final encryptedIv = RSAPublicKey.fromPEM(rsaPublicKey).encrypt(iv.base16);

    List<List<int>> combined = [utf8.encode(encryptedIv), encrypted.bytes];
    var bytes = Uint8List.fromList(combined.expand((e) => e).toList());
    var encryptedData = base64Encode(bytes);

    return encryptedData;
  }

  String decrypt(String encrypted) {
    RSAPrivateKey rsaPrivateKey =
        RSAPrivateKey.fromPEM(utf8.decode(base64Decode(selfPrivateKey)));
    enc.Key key = enc.Key.fromBase64(aesKey);

    Uint8List encryptedBuffer = base64Decode(encrypted);
    List<int> ivBuffer;
    List<int> encryptedDataBuffer;

    ivBuffer = encryptedBuffer.getRange(0, 344).toList();
    encryptedDataBuffer = encryptedBuffer
        .getRange(
          344,
          encryptedBuffer.length,
        )
        .toList();
    var decryptedIv = rsaPrivateKey.decrypt(utf8.decode(ivBuffer));
    var iv = enc.IV.fromBase64(decryptedIv);
    enc.Encrypted encryptedData =
        enc.Encrypted.fromBase64(base64Encode(encryptedDataBuffer));

    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final finalDecrypted = encrypter.decrypt(encryptedData, iv: iv);

    return finalDecrypted;
  }
}
