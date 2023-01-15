import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inbox_state.g.dart';

@JsonSerializable(
  ignoreUnannotated: true,
)
class InboxState with EquatableMixin {
  final bool isLoaded;

  final Iterable<int> inboxTags;

  final Iterable<DocumentModel> inboxItems;

  final Map<int, Tag> availableTags;

  final Map<int, DocumentType> availableDocumentTypes;

  final Map<int, Correspondent> availableCorrespondents;

  final Map<int, FieldSuggestions> suggestions;
  @JsonKey()
  final bool isHintAcknowledged;

  const InboxState({
    this.isLoaded = false,
    this.inboxTags = const [],
    this.inboxItems = const [],
    this.isHintAcknowledged = false,
    this.availableTags = const {},
    this.availableDocumentTypes = const {},
    this.availableCorrespondents = const {},
    this.suggestions = const {},
  });

  @override
  List<Object?> get props => [
        isLoaded,
        inboxTags,
        inboxItems,
        isHintAcknowledged,
        availableTags,
        availableDocumentTypes,
        availableCorrespondents,
        suggestions,
      ];

  InboxState copyWith({
    bool? isLoaded,
    Iterable<int>? inboxTags,
    Iterable<DocumentModel>? inboxItems,
    bool? isHintAcknowledged,
    Map<int, Tag>? availableTags,
    Map<int, Correspondent>? availableCorrespondents,
    Map<int, DocumentType>? availableDocumentTypes,
    Map<int, FieldSuggestions>? suggestions,
  }) {
    return InboxState(
      isLoaded: isLoaded ?? this.isLoaded,
      inboxItems: inboxItems ?? this.inboxItems,
      inboxTags: inboxTags ?? this.inboxTags,
      isHintAcknowledged: isHintAcknowledged ?? this.isHintAcknowledged,
      availableCorrespondents:
          availableCorrespondents ?? this.availableCorrespondents,
      availableDocumentTypes:
          availableDocumentTypes ?? this.availableDocumentTypes,
      availableTags: availableTags ?? this.availableTags,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  factory InboxState.fromJson(Map<String, dynamic> json) =>
      _$InboxStateFromJson(json);

  Map<String, dynamic> toJson() => _$InboxStateToJson(this);
}
