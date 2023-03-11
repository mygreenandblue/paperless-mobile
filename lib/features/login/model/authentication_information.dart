import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_mobile/features/login/model/basic_auth_model.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';

part 'authentication_information.g.dart';

@JsonSerializable()
class AuthenticationInformation {
  final String? token;
  final String serverUrl;
  final ClientCertificate? clientCertificate;
  final BasicAuthModel? basicAuth;

  AuthenticationInformation({
    this.token,
    required this.serverUrl,
    this.clientCertificate,
    this.basicAuth,
  });

  bool get isValid {
    return serverUrl.isNotEmpty && (token?.isNotEmpty ?? false);
  }

  AuthenticationInformation copyWith({
    String? token,
    String? serverUrl,
    ClientCertificate? Function()? clientCertificate,
    BasicAuthModel? Function()? basicAuth,
  }) {
    return AuthenticationInformation(
      token: token ?? this.token,
      serverUrl: serverUrl ?? this.serverUrl,
      clientCertificate: clientCertificate != null
          ? clientCertificate()
          : this.clientCertificate,
      basicAuth: basicAuth != null ? basicAuth() : this.basicAuth,
    );
  }

  factory AuthenticationInformation.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationInformationFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationInformationToJson(this);
}
