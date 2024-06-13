import 'package:hive/hive.dart';
import 'package:edocs_mobile/core/database/hive/hive_config.dart';
import 'package:edocs_mobile/features/login/model/client_certificate.dart';

part 'user_credentials.g.dart';

@HiveType(typeId: HiveTypeIds.localUserCredentials)
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
