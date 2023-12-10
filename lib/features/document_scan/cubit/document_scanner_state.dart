part of 'document_scanner_cubit.dart';

@freezed
class DocumentScannerState with _$DocumentScannerState {
  const factory DocumentScannerState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<File> scans,
  }) = _DocumentScannerState;
}
