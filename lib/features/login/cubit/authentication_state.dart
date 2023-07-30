part of 'authentication_cubit.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const AuthenticationState._();

  const factory AuthenticationState.unauthenticated() = _Unauthenticated;
  const factory AuthenticationState.requriresLocalAuthentication() =
      _RequiresLocalAuthentication;
  const factory AuthenticationState.authenticated({
    required String localUserId,
  }) = _Authenticated;
  const factory AuthenticationState.switchingAccounts() = _SwitchingAccounts;

  bool get isAuthenticated => maybeWhen(
        authenticated: (_) => true,
        orElse: () => false,
      );
}
