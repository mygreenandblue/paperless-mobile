abstract class EdocsAuthenticationApi {
  Future<String> login({
    required String username,
    required String password,
  });
}
