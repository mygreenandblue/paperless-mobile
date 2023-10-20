part of 'document_upload_cubit.dart';

@immutable
class DocumentUploadState {
  final double? uploadProgress;
  const DocumentUploadState({
    this.uploadProgress,
  });

  DocumentUploadState copyWith({
    double? uploadProgress,
  }) {
    return DocumentUploadState(
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }
}
