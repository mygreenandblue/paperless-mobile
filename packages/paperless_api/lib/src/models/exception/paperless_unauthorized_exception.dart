class PaperlessUnauthorizedException implements Exception {
  final String? message;

  PaperlessUnauthorizedException(this.message);
}
