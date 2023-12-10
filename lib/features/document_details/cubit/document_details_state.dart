part of 'document_details_cubit.dart';

@freezed
class DocumentDetailsState with _$DocumentDetailsState {
  const factory DocumentDetailsState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    DocumentModel? document,
    DocumentMetaData? metaData,
  }) = _DocumentDetailsState;
}
