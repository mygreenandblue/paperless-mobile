part of 'document_scanner_cubit.dart';

sealed class DocumentScannerState {
  final List<File> scans;

  const DocumentScannerState({
    this.scans = const [],
  });
}

class InitialDocumentScannerState extends DocumentScannerState {
  const InitialDocumentScannerState();
}

class RestoringDocumentScannerState extends DocumentScannerState {
  const RestoringDocumentScannerState({super.scans});
}

class LoadedDocumentScannerState extends DocumentScannerState {
  const LoadedDocumentScannerState({super.scans});
}

class ErrorDocumentScannerState extends DocumentScannerState {
  final String message;

  const ErrorDocumentScannerState({
    required this.message,
    super.scans,
  });
}
