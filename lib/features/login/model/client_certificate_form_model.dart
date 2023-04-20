import 'dart:convert';
import 'dart:typed_data';

class ClientCertificateFormModel {
  static const bytesKey = 'bytes';
  static const passphraseKey = 'passphrase';

  final Uint8List bytes;
  final String? passphrase;

  ClientCertificateFormModel({required this.bytes, this.passphrase});

  ClientCertificateFormModel copyWith({Uint8List? bytes, String? passphrase}) {
    return ClientCertificateFormModel(
      bytes: bytes ?? this.bytes,
      passphrase: passphrase ?? this.passphrase,
    );
  }
}
