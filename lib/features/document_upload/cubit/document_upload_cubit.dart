import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/bloc/transient_error.dart';
import 'package:edocs_mobile/core/repository/label_repository.dart';
import 'package:edocs_mobile/core/service/connectivity_status_service.dart';
import 'package:edocs_mobile/features/logging/data/mirrored_file_output.dart';
import 'package:edocs_mobile/features/tasks/model/pending_tasks_notifier.dart';

part 'document_upload_state.dart';

class DocumentUploadCubit extends Cubit<DocumentUploadState> {
  final EdocsDocumentsApi _documentApi;
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
    int? folder,
  }) async {
    try {
      final taskId = await _documentApi.create(bytes,
          filename: filename,
          title: title,
          correspondent: correspondent,
          documentType: documentType,
          tags: tags,
          createdAt: createdAt,
          asn: asn,
          warehouse: warehouse, onProgressChanged: (progress) {
        if (!isClosed) {
          emit(state.copyWith(uploadProgress: progress));
        }
      }, folder: folder);

      if (taskId != null) {
        _tasksNotifier.listenToTaskChanges(taskId);
      }
      return taskId;
    } on EdocsApiException catch (error) {
      addError(TransientedocsApiError(
        code: error.code,
        details: error.details,
      ));
    }
    return null;
  }
}
