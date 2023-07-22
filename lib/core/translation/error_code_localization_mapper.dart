import 'package:flutter/cupertino.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

String translateError(BuildContext context, ErrorCode code) {
  return switch (code) {
    ErrorCode.unknown => S.of(context)!.anUnknownErrorOccurred,
    ErrorCode.authenticationFailed =>
      S.of(context)!.authenticationFailedPleaseTryAgain,
    ErrorCode.notAuthenticated => S.of(context)!.userIsNotAuthenticated,
    ErrorCode.documentUploadFailed => S.of(context)!.couldNotUploadDocument,
    ErrorCode.documentUpdateFailed => S.of(context)!.couldNotUpdateDocument,
    ErrorCode.documentLoadFailed => S.of(context)!.couldNotLoadDocuments,
    ErrorCode.documentDeleteFailed => S.of(context)!.couldNotDeleteDocument,
    ErrorCode.documentPreviewFailed =>
      S.of(context)!.couldNotLoadDocumentPreview,
    ErrorCode.documentAsnQueryFailed =>
      S.of(context)!.couldNotAssignArchiveSerialNumber,
    ErrorCode.tagCreateFailed => S.of(context)!.couldNotCreateTag,
    ErrorCode.tagLoadFailed => S.of(context)!.couldNotLoadTags,
    ErrorCode.documentTypeCreateFailed => S.of(context)!.couldNotCreateDocument,
    ErrorCode.documentTypeLoadFailed =>
      S.of(context)!.couldNotLoadDocumentTypes,
    ErrorCode.correspondentCreateFailed =>
      S.of(context)!.couldNotCreateCorrespondent,
    ErrorCode.correspondentLoadFailed =>
      S.of(context)!.couldNotLoadCorrespondents,
    ErrorCode.scanRemoveFailed =>
      S.of(context)!.anErrorOccurredRemovingTheScans,
    ErrorCode.invalidClientCertificateConfiguration =>
      S.of(context)!.invalidCertificateOrMissingPassphrase,
    ErrorCode.documentBulkActionFailed =>
      S.of(context)!.couldNotBulkEditDocuments,
    ErrorCode.biometricsNotSupported =>
      S.of(context)!.biometricAuthenticationNotSupported,
    ErrorCode.biometricAuthenticationFailed =>
      S.of(context)!.biometricAuthenticationFailed,
    ErrorCode.deviceOffline => S.of(context)!.youAreCurrentlyOffline,
    ErrorCode.serverUnreachable =>
      S.of(context)!.couldNotReachYourPaperlessServer,
    ErrorCode.similarQueryError => S.of(context)!.couldNotLoadSimilarDocuments,
    ErrorCode.autocompleteQueryError =>
      S.of(context)!.anErrorOccurredWhileTryingToAutocompleteYourQuery,
    ErrorCode.storagePathLoadFailed => S.of(context)!.couldNotLoadStoragePaths,
    ErrorCode.storagePathCreateFailed =>
      S.of(context)!.couldNotCreateStoragePath,
    ErrorCode.loadSavedViewsError => S.of(context)!.couldNotLoadSavedViews,
    ErrorCode.createSavedViewError => S.of(context)!.couldNotCreateSavedView,
    ErrorCode.deleteSavedViewError => S.of(context)!.couldNotDeleteSavedView,
    ErrorCode.requestTimedOut => S.of(context)!.requestTimedOut,
    ErrorCode.unsupportedFileFormat => S.of(context)!.fileFormatNotSupported,
    ErrorCode.missingClientCertificate =>
      S.of(context)!.aClientCertificateWasExpectedButNotSent,
    ErrorCode.suggestionsQueryError => S.of(context)!.couldNotLoadSuggestions,
    ErrorCode.acknowledgeTasksError => S.of(context)!.couldNotAcknowledgeTasks,
    ErrorCode.correspondentDeleteFailed =>
      "Could not delete correspondent, please try again.",
    ErrorCode.documentTypeDeleteFailed =>
      "Could not delete document type, please try again.",
    ErrorCode.tagDeleteFailed => "Could not delete tag, please try again.",
    ErrorCode.correspondentUpdateFailed =>
      "Could not update correspondent, please try again.",
    ErrorCode.documentTypeUpdateFailed =>
      "Could not update document type, please try again.",
    ErrorCode.tagUpdateFailed => "Could not update tag, please try again.",
    ErrorCode.storagePathDeleteFailed =>
      "Could not delete storage path, please try again.",
    ErrorCode.storagePathUpdateFailed =>
      "Could not update storage path, please try again.",
    ErrorCode.serverInformationLoadFailed =>
      "Could not load server information.",
    ErrorCode.serverStatisticsLoadFailed => "Could not load server statistics.",
    ErrorCode.uiSettingsLoadFailed => "Could not load UI settings",
    ErrorCode.loadTasksError => "Could not load tasks.",
    ErrorCode.userNotFound => "User could not be found.",
  };
}
