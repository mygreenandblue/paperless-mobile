import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/logging/logger.dart';
import 'package:paperless_mobile/core/model/info_message_exception.dart';
import 'package:paperless_mobile/core/service/file_service.dart';
import 'package:paperless_mobile/features/notifications/services/local_notification_service.dart';
import 'package:rxdart/rxdart.dart';

part 'document_scanner_state.dart';

class DocumentScannerCubit extends Cubit<DocumentScannerState> {
  final LocalNotificationService _notificationService;

  DocumentScannerCubit(this._notificationService)
      : super(const InitialDocumentScannerState());

  Future<void> initialize() async {
    logger.t("Restoring scans...");
    emit(const RestoringDocumentScannerState());
    final tempDir = await FileService.temporaryScansDirectory;
    final allFiles = tempDir.list().whereType<File>();
    final scans =
        await allFiles.where((event) => event.path.endsWith(".jpeg")).toList();
    logger.t("Restored ${scans.length} scans.");
    emit(
      scans.isEmpty
          ? const InitialDocumentScannerState()
          : LoadedDocumentScannerState(scans: scans),
    );
  }

  void addScan(File file) async {
    emit(LoadedDocumentScannerState(
      scans: [...state.scans, file],
    ));
  }

  Future<void> removeScan(File file) async {
    try {
      await file.delete();
    } catch (error, stackTrace) {
      throw InfoMessageException(
        code: ErrorCode.scanRemoveFailed,
        message: error.toString(),
        stackTrace: stackTrace,
      );
    }
    final scans = state.scans..remove(file);
    emit(
      scans.isEmpty
          ? const InitialDocumentScannerState()
          : LoadedDocumentScannerState(scans: scans),
    );
  }

  Future<void> reset() async {
    try {
      Future.wait([
        for (final file in state.scans) file.delete(),
      ]);
      imageCache.clear();
    } catch (_) {
      throw const PaperlessApiException(ErrorCode.scanRemoveFailed);
    } finally {
      emit(const InitialDocumentScannerState());
    }
  }

  Future<void> saveToFile(
    Uint8List bytes,
    String fileName,
    String locale,
  ) async {
    var file = await FileService.saveToFile(bytes, fileName);
    _notificationService.notifyFileSaved(
      filename: fileName,
      filePath: file.path,
      finished: true,
      locale: locale,
    );
  }
}
