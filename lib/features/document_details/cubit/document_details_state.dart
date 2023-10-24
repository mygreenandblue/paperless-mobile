part of 'document_details_cubit.dart';

sealed class DocumentDetailsState {
  const DocumentDetailsState();
}

class DocumentDetailsInitial extends DocumentDetailsState {
  const DocumentDetailsInitial();
}

class DocumentDetailsLoading extends DocumentDetailsState {
  const DocumentDetailsLoading();
}

class DocumentDetailsLoaded extends DocumentDetailsState {
  final DocumentModel document;
  final DocumentMetaData metaData;

  const DocumentDetailsLoaded({
    required this.document,
    required this.metaData,
  });
}

class DocumentDetailsError extends DocumentDetailsState {
  const DocumentDetailsError();
}


// @freezed
// class DocumentDetailsState with _$DocumentDetailsState {
//   const factory DocumentDetailsState({
//     required DocumentModel document,
//     DocumentMetaData? metaData,
//     @Default(false) bool isFullContentLoaded,
//     @Default({}) Map<int, Correspondent> correspondents,
//     @Default({}) Map<int, DocumentType> documentTypes,
//     @Default({}) Map<int, Tag> tags,
//     @Default({}) Map<int, StoragePath> storagePaths,
//   }) = _DocumentDetailsState;
// }
