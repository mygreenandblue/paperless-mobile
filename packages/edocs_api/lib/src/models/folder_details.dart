// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:edocs_api/edocs_api.dart';
part 'folder_details.freezed.dart';
part 'folder_details.g.dart';

@freezed
class FolderDetails with _$FolderDetails {
  const factory FolderDetails({
    required List<DocumentModel>? documents,
    required List<Folder>? folders,
  }) = _FolderDetails;

  factory FolderDetails.fromJson(Map<String, dynamic> json) =>
      _$FolderDetailsFromJson(json);
}
