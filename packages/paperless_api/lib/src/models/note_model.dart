// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
part 'note_model.freezed.dart';
part 'note_model.g.dart';

@freezed
class NoteModel with _$NoteModel {
  const factory NoteModel({
    required int? id,
    required String? note,
    required DateTime? created,
    required int? document,
    @JsonKey(fromJson: parseNoteUserFromJson) required int? user,
  }) = _NoteModel;

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);
}

int? parseNoteUserFromJson(dynamic json) {
  if (json == null) return null;
  if (json is Map) {
    return json['id'];
  } else if (json is int) {
    return json;
  }
  return null;
}
