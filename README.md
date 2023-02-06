# fe2ee
 
This is flutter package for simple end to end encryption. Using simple AES and RSA combination.

For NodeJs version you can look [here](https://github.com/Anshor15/ne2ee).

# Example

```dart
import 'package:flutter/material.dart';
import 'package:fe2ee/fe2ee.dart';
import 'package:encrypt/encrypt.dart' as enc;

class MyEncrypt extends StatefulWidget {
  const MyEncrypt({super.key});

  @override
  State<MyEncrypt> createState() => _MyEncryptState();
}

class _MyEncryptState extends State<MyEncrypt> {
  var privateKey;
  var publicKey;
  var aesKey;

  var encrypted;
  var decrypted;

  TextEditingController plain = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Column(
                      children: [
                        const Text('Private Key'),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(privateKey ?? ''),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Column(
                      children: [
                        const Text('Public Key'),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(publicKey ?? ''),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Column(
                      children: [
                        const Text('AES Key'),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(aesKey ?? ''),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        genereateKey();
                      },
                      child: Text("Generate Key")),
                  TextFormField(
                    controller: plain,
                    decoration: const InputDecoration(
                      hintText: "Text",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      encrypt(plain.text);
                    },
                    child: const Text("Encrypt"),
                  ),
                  Text(encrypted ?? ''),
                  ElevatedButton(
                    onPressed: () {
                      decrypt(encrypted);
                    },
                    child: const Text("Decrypt"),
                  ),
                  Text(decrypted ?? '')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void genereateKey() {
    var keyPair = GenerateKey().get();
    setState(() {
      publicKey = keyPair.rsaKeypair.publicKey.toPEM();
      privateKey = keyPair.rsaKeypair.privateKey.toPEM();
      aesKey = keyPair.aesKey.base16;
    });
  }

  void encrypt(String data) {
    var e2ee = FE2EE(
      selfPrivateKey: privateKey,
      publicKey: publicKey,
      aesKey: enc.Key.fromBase16(aesKey),
    );

    setState(() {
      encrypted = e2ee.encrypt(data);
    });
  }

  void decrypt(String encrypted) {
    var e2ee = FE2EE(
      selfPrivateKey: privateKey,
      publicKey: publicKey,
      aesKey: enc.Key.fromBase16(aesKey),
    );

    setState(() {
      decrypted = e2ee.decrypt(encrypted);
    });
  }
}

```