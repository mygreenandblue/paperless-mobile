class LoginFormCredentials {
  final String? username;
  final String? password;

  LoginFormCredentials({this.username, this.password});

  LoginFormCredentials copyWith({String? username, String? password}) {
    return LoginFormCredentials(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
