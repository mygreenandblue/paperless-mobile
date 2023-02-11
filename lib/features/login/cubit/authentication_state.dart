part of 'authentication_cubit.dart';

@JsonSerializable()
class AuthenticationState {
  final bool wasLoginStored;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool? wasLocalAuthenticationSuccessful;
  final AuthenticationInformation? authentication;

  static final AuthenticationState initial = AuthenticationState(
    wasLoginStored: false,
  );

  bool get isAuthenticated => authentication != null;
  AuthenticationState({
    required this.wasLoginStored,
    this.wasLocalAuthenticationSuccessful,
    this.authentication,
  });

  AuthenticationState copyWith({
    bool? wasLoginStored,
    bool? isAuthenticated,
    AuthenticationInformation? authentication,
    bool? wasLocalAuthenticationSuccessful,
  }) {
    return AuthenticationState(
      wasLoginStored: wasLoginStored ?? this.wasLoginStored,
      authentication: authentication ?? this.authentication,
      wasLocalAuthenticationSuccessful: wasLocalAuthenticationSuccessful ??
          this.wasLocalAuthenticationSuccessful,
    );
  }

  factory AuthenticationState.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationStateFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationStateToJson(this);
}
