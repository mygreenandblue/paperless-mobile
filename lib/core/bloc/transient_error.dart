import 'package:edocs_api/edocs_api.dart';

sealed class TransientError extends Error {}

class TransientedocsApiError extends TransientError {
  final ErrorCode code;
  final String? details;

  TransientedocsApiError({required this.code, this.details});
}

class TransientMessageError extends TransientError {
  final String message;

  TransientMessageError({required this.message});
}
