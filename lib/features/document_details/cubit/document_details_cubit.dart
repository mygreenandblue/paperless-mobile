import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/service/file_service.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';
import 'package:paperless_mobile/features/notifications/services/local_notification_service.dart';
import 'package:path/path.dart' as p;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

part 'document_details_state.dart';

class DocumentDetailsCubit extends Cubit<DocumentDetailsState> {
  final int id;
  final PaperlessDocumentsApi _api;
  final DocumentChangedNotifier _notifier;
  final LocalNotificationService _notificationService;
  final LabelRepository _labelRepository;

  DocumentDetailsCubit(
    this._api,
    this._labelRepository,
    this._notifier,
    this._notificationService, {
    required this.id,
  }) : super(const DocumentDetailsInitial()) {
    _notifier.addListener(this, onUpdated: (document) {
      if (state is DocumentDetailsLoaded) {
        final currentState = state as DocumentDetailsLoaded;
        if (document.id == currentState.document.id) {
          replace(document);
        }
      }
    });
  }

  Future<void> initialize() async {
    debugPrint("Initialize called");
    emit(const DocumentDetailsLoading());
    try {
      final (document, metaData) = await Future.wait([
        _api.find(id),
        _api.getMetaData(id),
      ]).then((value) => (
            value[0] as DocumentModel,
            value[1] as DocumentMetaData,
          ));
      // final document = await _api.find(id);
      // final metaData = await _api.getMetaData(id);
      debugPrint("Document data loaded for $id");
      emit(DocumentDetailsLoaded(
        document: document,
        metaData: metaData,
      ));
    } catch (error, stackTrace) {
      logger.fe(
        "An error occurred while loading data for document $id.",
        className: runtimeType.toString(),
        methodName: 'initialize',
        error: error,
        stackTrace: stackTrace,
      );
      emit(const DocumentDetailsError());
    }
  }

  Future<void> delete(DocumentModel document) async {
    await _api.delete(document);
    _notifier.notifyDeleted(document);
  }

  Future<void> assignAsn(
    DocumentModel document, {
    int? asn,
    bool autoAssign = false,
  }) async {
    if (!autoAssign) {
      final updatedDocument = await _api.update(
        document.copyWith(archiveSerialNumber: () => asn),
      );
      _notifier.notifyUpdated(updatedDocument);
    } else {
      final int autoAsn = await _api.findNextAsn();
      final updatedDocument = await _api
          .update(document.copyWith(archiveSerialNumber: () => autoAsn));
      _notifier.notifyUpdated(updatedDocument);
    }
  }

  Future<ResultType> openDocumentInSystemViewer() async {
    final s = state;
    if (s is! DocumentDetailsLoaded) {
      throw Exception(
        "Document cannot be opened in system viewer "
        "if document information has not yet been loaded.",
      );
    }
    final cacheDir = FileService.instance.temporaryDirectory;
    final filePath = s.metaData.mediaFilename.replaceAll("/", " ");

    final fileName = "${p.basenameWithoutExtension(filePath)}.pdf";
    final file = File("${cacheDir.path}/$fileName");

    if (!file.existsSync()) {
      file.createSync();
      await _api.downloadToFile(
        s.document,
        file.path,
      );
    }
    return OpenFilex.open(
      file.path,
      type: "application/pdf",
    ).then((value) => value.type);
  }

  void replace(DocumentModel document) {
    final s = state;
    if (s is! DocumentDetailsLoaded) {
      return;
    }
    emit(DocumentDetailsLoaded(
      document: document,
      metaData: s.metaData,
    ));
  }

  Future<void> downloadDocument({
    bool downloadOriginal = false,
    required String locale,
    required String userId,
  }) async {
    final s = state;
    if (s is! DocumentDetailsLoaded) {
      return;
    }
    String targetPath = _buildDownloadFilePath(
      s.metaData,
      downloadOriginal,
      FileService.instance.downloadsDirectory,
    );

    if (!await File(targetPath).exists()) {
      await File(targetPath).create();
    } else {
      await _notificationService.notifyDocumentDownload(
        document: s.document,
        filename: p.basename(targetPath),
        filePath: targetPath,
        finished: true,
        locale: locale,
        userId: userId,
      );
    }

    // await _notificationService.notifyFileDownload(
    //   document: state.document,
    //   filename: p.basename(targetPath),
    //   filePath: targetPath,
    //   finished: false,
    //   locale: locale,
    //   userId: userId,
    // );

    await _api.downloadToFile(
      s.document,
      targetPath,
      original: downloadOriginal,
      onProgressChanged: (progress) {
        _notificationService.notifyDocumentDownload(
          document: s.document,
          filename: p.basename(targetPath),
          filePath: targetPath,
          finished: true,
          locale: locale,
          userId: userId,
          progress: progress,
        );
      },
    );
    await _notificationService.notifyDocumentDownload(
      document: s.document,
      filename: p.basename(targetPath),
      filePath: targetPath,
      finished: true,
      locale: locale,
      userId: userId,
    );
    logger.fi("Document '${s.document.title}' saved to $targetPath.");
  }

  Future<void> shareDocument({bool shareOriginal = false}) async {
    final s = state;
    if (s is! DocumentDetailsLoaded) {
      return;
    }
    String filePath = _buildDownloadFilePath(
      s.metaData,
      shareOriginal,
      FileService.instance.temporaryDirectory,
    );
    await _api.downloadToFile(
      s.document,
      filePath,
      original: shareOriginal,
    );
    Share.shareXFiles(
      [
        XFile(
          filePath,
          name: s.document.originalFileName,
          mimeType: "application/pdf",
          lastModified: s.document.modified,
        ),
      ],
      subject: s.document.title,
    );
  }

  Future<void> printDocument() async {
    final s = state;
    if (s is! DocumentDetailsLoaded) {
      return;
    }
    final filePath = _buildDownloadFilePath(
      s.metaData,
      false,
      FileService.instance.temporaryDirectory,
    );
    await _api.downloadToFile(
      s.document,
      filePath,
      original: false,
    );
    final file = File(filePath);
    if (!file.existsSync()) {
      throw Exception("An error occurred while downloading the document.");
    }
    Printing.layoutPdf(
      name: s.document.title,
      onLayout: (format) => file.readAsBytesSync(),
    );
  }

  String _buildDownloadFilePath(
      DocumentMetaData meta, bool original, Directory dir) {
    final normalizedPath = meta.mediaFilename.replaceAll("/", " ");
    final extension = original ? p.extension(normalizedPath) : '.pdf';
    return "${dir.path}/${p.basenameWithoutExtension(normalizedPath)}$extension";
  }

  @override
  Future<void> close() async {
    _labelRepository.removeListener(this);
    _notifier.removeListener(this);
    await super.close();
  }
}
