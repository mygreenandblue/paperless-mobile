// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_edit_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DocumentEditState {
  DocumentModel get document => throw _privateConstructorUsedError;
  Map<int, Correspondent> get correspondents =>
      throw _privateConstructorUsedError;
  Map<int, DocumentType> get documentTypes =>
      throw _privateConstructorUsedError;
  Map<int, StoragePath> get storagePaths => throw _privateConstructorUsedError;
  Map<int, Tag> get tags => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DocumentEditStateCopyWith<DocumentEditState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentEditStateCopyWith<$Res> {
  factory $DocumentEditStateCopyWith(
          DocumentEditState value, $Res Function(DocumentEditState) then) =
      _$DocumentEditStateCopyWithImpl<$Res, DocumentEditState>;
  @useResult
  $Res call(
      {DocumentModel document,
      Map<int, Correspondent> correspondents,
      Map<int, DocumentType> documentTypes,
      Map<int, StoragePath> storagePaths,
      Map<int, Tag> tags});
}

/// @nodoc
class _$DocumentEditStateCopyWithImpl<$Res, $Val extends DocumentEditState>
    implements $DocumentEditStateCopyWith<$Res> {
  _$DocumentEditStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? document = null,
    Object? correspondents = null,
    Object? documentTypes = null,
    Object? storagePaths = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      document: null == document
          ? _value.document
          : document // ignore: cast_nullable_to_non_nullable
              as DocumentModel,
      correspondents: null == correspondents
          ? _value.correspondents
          : correspondents // ignore: cast_nullable_to_non_nullable
              as Map<int, Correspondent>,
      documentTypes: null == documentTypes
          ? _value.documentTypes
          : documentTypes // ignore: cast_nullable_to_non_nullable
              as Map<int, DocumentType>,
      storagePaths: null == storagePaths
          ? _value.storagePaths
          : storagePaths // ignore: cast_nullable_to_non_nullable
              as Map<int, StoragePath>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Map<int, Tag>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DocumentEditStateCopyWith<$Res>
    implements $DocumentEditStateCopyWith<$Res> {
  factory _$$_DocumentEditStateCopyWith(_$_DocumentEditState value,
          $Res Function(_$_DocumentEditState) then) =
      __$$_DocumentEditStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DocumentModel document,
      Map<int, Correspondent> correspondents,
      Map<int, DocumentType> documentTypes,
      Map<int, StoragePath> storagePaths,
      Map<int, Tag> tags});
}

/// @nodoc
class __$$_DocumentEditStateCopyWithImpl<$Res>
    extends _$DocumentEditStateCopyWithImpl<$Res, _$_DocumentEditState>
    implements _$$_DocumentEditStateCopyWith<$Res> {
  __$$_DocumentEditStateCopyWithImpl(
      _$_DocumentEditState _value, $Res Function(_$_DocumentEditState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? document = null,
    Object? correspondents = null,
    Object? documentTypes = null,
    Object? storagePaths = null,
    Object? tags = null,
  }) {
    return _then(_$_DocumentEditState(
      document: null == document
          ? _value.document
          : document // ignore: cast_nullable_to_non_nullable
              as DocumentModel,
      correspondents: null == correspondents
          ? _value._correspondents
          : correspondents // ignore: cast_nullable_to_non_nullable
              as Map<int, Correspondent>,
      documentTypes: null == documentTypes
          ? _value._documentTypes
          : documentTypes // ignore: cast_nullable_to_non_nullable
              as Map<int, DocumentType>,
      storagePaths: null == storagePaths
          ? _value._storagePaths
          : storagePaths // ignore: cast_nullable_to_non_nullable
              as Map<int, StoragePath>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Map<int, Tag>,
    ));
  }
}

/// @nodoc

class _$_DocumentEditState implements _DocumentEditState {
  const _$_DocumentEditState(
      {required this.document,
      required final Map<int, Correspondent> correspondents,
      required final Map<int, DocumentType> documentTypes,
      required final Map<int, StoragePath> storagePaths,
      required final Map<int, Tag> tags})
      : _correspondents = correspondents,
        _documentTypes = documentTypes,
        _storagePaths = storagePaths,
        _tags = tags;

  @override
  final DocumentModel document;
  final Map<int, Correspondent> _correspondents;
  @override
  Map<int, Correspondent> get correspondents {
    if (_correspondents is EqualUnmodifiableMapView) return _correspondents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_correspondents);
  }

  final Map<int, DocumentType> _documentTypes;
  @override
  Map<int, DocumentType> get documentTypes {
    if (_documentTypes is EqualUnmodifiableMapView) return _documentTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_documentTypes);
  }

  final Map<int, StoragePath> _storagePaths;
  @override
  Map<int, StoragePath> get storagePaths {
    if (_storagePaths is EqualUnmodifiableMapView) return _storagePaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_storagePaths);
  }

  final Map<int, Tag> _tags;
  @override
  Map<int, Tag> get tags {
    if (_tags is EqualUnmodifiableMapView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tags);
  }

  @override
  String toString() {
    return 'DocumentEditState(document: $document, correspondents: $correspondents, documentTypes: $documentTypes, storagePaths: $storagePaths, tags: $tags)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DocumentEditState &&
            (identical(other.document, document) ||
                other.document == document) &&
            const DeepCollectionEquality()
                .equals(other._correspondents, _correspondents) &&
            const DeepCollectionEquality()
                .equals(other._documentTypes, _documentTypes) &&
            const DeepCollectionEquality()
                .equals(other._storagePaths, _storagePaths) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      document,
      const DeepCollectionEquality().hash(_correspondents),
      const DeepCollectionEquality().hash(_documentTypes),
      const DeepCollectionEquality().hash(_storagePaths),
      const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DocumentEditStateCopyWith<_$_DocumentEditState> get copyWith =>
      __$$_DocumentEditStateCopyWithImpl<_$_DocumentEditState>(
          this, _$identity);
}

abstract class _DocumentEditState implements DocumentEditState {
  const factory _DocumentEditState(
      {required final DocumentModel document,
      required final Map<int, Correspondent> correspondents,
      required final Map<int, DocumentType> documentTypes,
      required final Map<int, StoragePath> storagePaths,
      required final Map<int, Tag> tags}) = _$_DocumentEditState;

  @override
  DocumentModel get document;
  @override
  Map<int, Correspondent> get correspondents;
  @override
  Map<int, DocumentType> get documentTypes;
  @override
  Map<int, StoragePath> get storagePaths;
  @override
  Map<int, Tag> get tags;
  @override
  @JsonKey(ignore: true)
  _$$_DocumentEditStateCopyWith<_$_DocumentEditState> get copyWith =>
      throw _privateConstructorUsedError;
}
