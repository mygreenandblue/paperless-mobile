part of 'authentication_cubit.dart';

sealed class AuthenticationState {
  const AuthenticationState();

  bool get isAuthenticated =>
      switch (this) { AuthenticatedState() => true, _ => false };
}

class UnauthenticatedState extends AuthenticationState {
  const UnauthenticatedState();
}

class RequiresLocalAuthenticationState extends AuthenticationState {
  const RequiresLocalAuthenticationState();
}

class AuthenticatedState extends AuthenticationState {
  final String localUserId;

  const AuthenticatedState({
    required this.localUserId,
  });
}

class SwitchingAccountsState extends AuthenticationState {
  const SwitchingAccountsState();
}

class AuthenticationErrorState extends AuthenticationState {
  const AuthenticationErrorState();
}
