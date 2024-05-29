import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/transient_error.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/features/tasks/model/pending_tasks_notifier.dart';

part 'document_upload_state.dart';

class DocumentUploadCubit extends Cubit<DocumentUploadState> {
  final PaperlessDocumentsApi _documentApi;
  final PendingTasksNotifier _tasksNotifier;
  final LabelRepository _labelRepository;
  final ConnectivityStatusService _connectivityStatusService;

  DocumentUploadCubit(
    this._labelRepository,
    this._documentApi,
    this._connectivityStatusService,
    this._tasksNotifier,
  ) : super(const DocumentUploadState());

  Future<String?> upload(
    Uint8List bytes, {
    required String filename,
    required String title,
    required String userId,
    int? documentType,
    int? correspondent,
    Iterable<int> tags = const [],
    DateTime? createdAt,
    int? asn,
    int? warehouse,
  }) async {
    try {
      final taskId = await _documentApi.create(
        bytes,
        filename: filename,
        title: title,
        correspondent: correspondent,
        documentType: documentType,
        tags: tags,
        createdAt: createdAt,
        asn: asn,
        warehouse: warehouse,
        onProgressChanged: (progress) {
          if (!isClosed) {
            emit(state.copyWith(uploadProgress: progress));
          }
        },
      );

      if (taskId != null) {
        _tasksNotifier.listenToTaskChanges(taskId);
      }
      return taskId;
    } on PaperlessApiException catch (error) {
      addError(TransientPaperlessApiError(
        code: error.code,
        details: error.details,
      ));
    }
    return null;
  }
}
