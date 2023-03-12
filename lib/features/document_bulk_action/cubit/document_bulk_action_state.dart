part of 'document_bulk_action_cubit.dart';

class DocumentBulkActionState extends Equatable {
  final List<DocumentModel> selection;
  final Map<int, Correspondent> correspondentOptions;
  final Map<int, DocumentType> documentTypeOptions;
  final Map<int, Tag> tagOptions;
  final Map<int, StoragePath> storagePathOptions;

  const DocumentBulkActionState({
    this.correspondentOptions = const {},
    this.documentTypeOptions = const {},
    this.tagOptions = const {},
    this.storagePathOptions = const {},
    this.selection = const [],
  });

  @override
  List<Object> get props => [
        selection,
        correspondentOptions,
        documentTypeOptions,
        tagOptions,
        storagePathOptions,
      ];

  Iterable<int> get selectedIds => selection.map((d) => d.id);

  DocumentBulkActionState copyWith({
    List<DocumentModel>? selection,
    Map<int, Correspondent>? correspondentOptions,
    Map<int, DocumentType>? documentTypeOptions,
    Map<int, Tag>? tagOptions,
    Map<int, StoragePath>? storagePathOptions,
  }) {
    return DocumentBulkActionState(
      selection: selection ?? this.selection,
      correspondentOptions: correspondentOptions ?? this.correspondentOptions,
      documentTypeOptions: documentTypeOptions ?? this.documentTypeOptions,
      storagePathOptions: storagePathOptions ?? this.storagePathOptions,
      tagOptions: tagOptions ?? this.tagOptions,
    );
  }
}
