part of 'authentication_cubit.dart';

class AuthenticationState with EquatableMixin {
  final bool showBiometricAuthenticationScreen;
  final bool isAuthenticated;
  final String? username;
  final String? fullName;
  final String? userId;

  const AuthenticationState({
    this.isAuthenticated = false,
    this.showBiometricAuthenticationScreen = false,
    this.username,
    this.fullName,
    this.userId,
  });

  AuthenticationState copyWith({
    bool? isAuthenticated,
    bool? showBiometricAuthenticationScreen,
    String? username,
    String? fullName,
    String? userId,
  }) {
    return AuthenticationState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      showBiometricAuthenticationScreen:
          showBiometricAuthenticationScreen ?? this.showBiometricAuthenticationScreen,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        username,
        fullName,
        isAuthenticated,
        showBiometricAuthenticationScreen,
      ];
}
