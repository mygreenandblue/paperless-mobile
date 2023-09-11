class PaperlessApiException implements Exception {
  final ErrorCode code;
  final String? details;
  final StackTrace? stackTrace;
  final int? httpStatusCode;

  const PaperlessApiException(
    this.code, {
    this.details,
    this.stackTrace,
    this.httpStatusCode,
  });

  const PaperlessApiException.unknown() : this(ErrorCode.unknown);

  @override
  String toString() {
    return "PaperlessServerException(code: $code${stackTrace != null ? ', stackTrace: ${stackTrace.toString()}' : ''}${httpStatusCode != null ? ', httpStatusCode: $httpStatusCode' : ''})";
  }
}

enum ErrorCode {
  unknown,
  authenticationFailed,
  notAuthenticated,
  documentUploadFailed,
  documentUpdateFailed,
  documentLoadFailed,
  documentDeleteFailed,
  documentBulkActionFailed,
  documentPreviewFailed,
  documentAsnQueryFailed,
  tagCreateFailed,
  tagLoadFailed,
  documentTypeCreateFailed,
  documentTypeLoadFailed,
  correspondentCreateFailed,
  correspondentLoadFailed,
  scanRemoveFailed,
  invalidClientCertificateConfiguration,
  biometricsNotSupported,
  biometricAuthenticationFailed,
  deviceOffline,
  serverUnreachable,
  similarQueryError,
  suggestionsQueryError,
  autocompleteQueryError,
  storagePathLoadFailed,
  storagePathCreateFailed,
  loadSavedViewsError,
  createSavedViewError,
  deleteSavedViewError,
  requestTimedOut,
  unsupportedFileFormat,
  missingClientCertificate,
  acknowledgeTasksError,
  correspondentDeleteFailed,
  documentTypeDeleteFailed,
  tagDeleteFailed,
  correspondentUpdateFailed,
  documentTypeUpdateFailed,
  tagUpdateFailed,
  storagePathDeleteFailed,
  storagePathUpdateFailed,
  serverInformationLoadFailed,
  serverStatisticsLoadFailed,
  uiSettingsLoadFailed,
  loadTasksError,
  userNotFound,
  updateSavedViewError;
}
