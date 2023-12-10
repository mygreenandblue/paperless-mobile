import 'package:paperless_api/paperless_api.dart';

sealed class TransientError extends Error {}

class TransientPaperlessApiError extends TransientError {
  final ErrorCode code;
  final String? details;

  TransientPaperlessApiError({required this.code, this.details});
}

class TransientMessageError extends TransientError {
  final String message;

  TransientMessageError({required this.message});
}
