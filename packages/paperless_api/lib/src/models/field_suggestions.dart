import 'package:json_annotation/json_annotation.dart';

part 'field_suggestions.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FieldSuggestions {
  final int? documentId;
  final Iterable<int> correspondents;
  final Iterable<int> tags;
  final Iterable<int> documentTypes;
  final Iterable<int> storagePaths;
  final Iterable<DateTime> dates;

  const FieldSuggestions({
    this.documentId,
    this.correspondents = const [],
    this.tags = const [],
    this.documentTypes = const [],
    this.storagePaths = const [],
    this.dates = const [],
  });

  bool get hasSuggestedCorrespondents => correspondents.isNotEmpty;
  bool get hasSuggestedTags => tags.isNotEmpty;
  bool get hasSuggestedDocumentTypes => documentTypes.isNotEmpty;
  bool get hasSuggestedStoragePaths => storagePaths.isNotEmpty;
  bool get hasSuggestedDates => dates.isNotEmpty;

  bool get hasSuggestions =>
      hasSuggestedCorrespondents ||
      hasSuggestedDates ||
      hasSuggestedTags ||
      hasSuggestedStoragePaths ||
      hasSuggestedDocumentTypes;

  int get suggestionsCount =>
      (correspondents.isNotEmpty ? 1 : 0) +
      (tags.isNotEmpty ? 1 : 0) +
      (documentTypes.isNotEmpty ? 1 : 0) +
      (storagePaths.isNotEmpty ? 1 : 0) +
      (dates.isNotEmpty ? 1 : 0);

  FieldSuggestions forDocumentId(int id) => FieldSuggestions(
        documentId: id,
        correspondents: correspondents,
        dates: dates,
        documentTypes: documentTypes,
        tags: tags,
        storagePaths: storagePaths,
      );

  factory FieldSuggestions.fromJson(Map<String, dynamic> json) =>
      _$FieldSuggestionsFromJson(json);

  Map<String, dynamic> toJson() => _$FieldSuggestionsToJson(this);
}
