import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/state/indexed_repository_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_type_repository_state.g.dart';

@JsonSerializable()
class DocumentTypeRepositoryState extends IndexedRepositoryState<DocumentType> {
  const DocumentTypeRepositoryState({
    super.values = const {},
    super.hasLoaded,
  });

  @override
  DocumentTypeRepositoryState copyWith({
    Map<int, DocumentType>? values,
    bool? hasLoaded,
  }) {
    return DocumentTypeRepositoryState(
      values: values ?? this.values,
      hasLoaded: hasLoaded ?? this.hasLoaded,
    );
  }

  factory DocumentTypeRepositoryState.fromJson(Map<String, dynamic> json) =>
      _$DocumentTypeRepositoryStateFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentTypeRepositoryStateToJson(this);
}
