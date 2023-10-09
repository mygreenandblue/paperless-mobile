import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:paperless_api/paperless_api.dart';
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
  ) : super(const DocumentUploadState()) {
    _labelRepository.addListener(
      this,
      onChanged: (labels) {
        emit(state.copyWith(
          correspondents: labels.correspondents,
          documentTypes: labels.documentTypes,
          tags: labels.tags,
        ));
      },
    );
  }

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
    void Function(double)? onProgressChanged,
  }) async {
    final taskId = await _documentApi.create(
      bytes,
      filename: filename,
      title: title,
      correspondent: correspondent,
      documentType: documentType,
      tags: tags,
      createdAt: createdAt,
      asn: asn,
      onProgressChanged: onProgressChanged,
    );
    if (taskId != null) {
      _tasksNotifier.listenToTaskChanges(taskId);
    }
    return taskId;
  }

  @override
  Future<void> close() async {
    _labelRepository.removeListener(this);
    return super.close();
  }
}
