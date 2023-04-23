import 'package:hive/hive.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';

part 'user_credentials.g.dart';

@HiveType(typeId: HiveTypeIds.userCredentials)
class UserCredentials extends HiveObject {
  @HiveField(0)
  final String token;
  @HiveField(1)
  final ClientCertificate? clientCertificate;

  UserCredentials({
    required this.token,
    this.clientCertificate,
  });
}
