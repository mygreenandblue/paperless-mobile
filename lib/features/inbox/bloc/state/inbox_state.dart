import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/paged_document_view/model/paged_documents_state.dart';

part 'inbox_state.g.dart';

@JsonSerializable(ignoreUnannotated: true)
class InboxState extends PagedDocumentsState {
  final Iterable<int> inboxTags;

  final Map<int, Tag> availableTags;

  final Map<int, DocumentType> availableDocumentTypes;

  final Map<int, Correspondent> availableCorrespondents;

  final int itemsInInboxCount;

  @JsonKey()
  final bool isHintAcknowledged;

  const InboxState({
    super.hasLoaded = false,
    super.isLoading = false,
    super.value = const [],
    super.filter = const DocumentFilter(),
    this.inboxTags = const [],
    this.isHintAcknowledged = false,
    this.availableTags = const {},
    this.availableDocumentTypes = const {},
    this.availableCorrespondents = const {},
    this.itemsInInboxCount = 0,
  });

  @override
  List<Object?> get props => [
        hasLoaded,
        isLoading,
        value,
        filter,
        inboxTags,
        documents,
        isHintAcknowledged,
        availableTags,
        availableDocumentTypes,
        availableCorrespondents,
        itemsInInboxCount,
      ];

  InboxState copyWith({
    bool? hasLoaded,
    bool? isLoading,
    Iterable<int>? inboxTags,
    List<PagedSearchResult<DocumentModel>>? value,
    DocumentFilter? filter,
    bool? isHintAcknowledged,
    Map<int, Tag>? availableTags,
    Map<int, Correspondent>? availableCorrespondents,
    Map<int, DocumentType>? availableDocumentTypes,
    Map<int, FieldSuggestions>? suggestions,
    int? itemsInInboxCount,
  }) {
    return InboxState(
      hasLoaded: hasLoaded ?? super.hasLoaded,
      isLoading: isLoading ?? super.isLoading,
      value: value ?? super.value,
      inboxTags: inboxTags ?? this.inboxTags,
      isHintAcknowledged: isHintAcknowledged ?? this.isHintAcknowledged,
      availableCorrespondents:
          availableCorrespondents ?? this.availableCorrespondents,
      availableDocumentTypes:
          availableDocumentTypes ?? this.availableDocumentTypes,
      availableTags: availableTags ?? this.availableTags,
      filter: filter ?? super.filter,
      itemsInInboxCount: itemsInInboxCount ?? this.itemsInInboxCount,
    );
  }

  factory InboxState.fromJson(Map<String, dynamic> json) =>
      _$InboxStateFromJson(json);

  Map<String, dynamic> toJson() => _$InboxStateToJson(this);

  @override
  InboxState copyWithPaged({
    bool? hasLoaded,
    bool? isLoading,
    List<PagedSearchResult<DocumentModel>>? value,
    DocumentFilter?
        filter, // Ignored as filter does not change while inbox is open
  }) {
    return copyWith(
      hasLoaded: hasLoaded,
      isLoading: isLoading,
      value: value,
      filter: filter,
    );
  }
}
