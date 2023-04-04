// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'label_repository_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LabelRepositoryState _$LabelRepositoryStateFromJson(Map<String, dynamic> json) {
  return _LabelRepositoryState.fromJson(json);
}

/// @nodoc
mixin _$LabelRepositoryState {
  Map<int, Correspondent> get correspondents =>
      throw _privateConstructorUsedError;
  Map<int, DocumentType> get documentTypes =>
      throw _privateConstructorUsedError;
  Map<int, Tag> get tags => throw _privateConstructorUsedError;
  Map<int, StoragePath> get storagePaths => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LabelRepositoryStateCopyWith<LabelRepositoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabelRepositoryStateCopyWith<$Res> {
  factory $LabelRepositoryStateCopyWith(LabelRepositoryState value,
          $Res Function(LabelRepositoryState) then) =
      _$LabelRepositoryStateCopyWithImpl<$Res, LabelRepositoryState>;
  @useResult
  $Res call(
      {Map<int, Correspondent> correspondents,
      Map<int, DocumentType> documentTypes,
      Map<int, Tag> tags,
      Map<int, StoragePath> storagePaths});
}

/// @nodoc
class _$LabelRepositoryStateCopyWithImpl<$Res,
        $Val extends LabelRepositoryState>
    implements $LabelRepositoryStateCopyWith<$Res> {
  _$LabelRepositoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? correspondents = null,
    Object? documentTypes = null,
    Object? tags = null,
    Object? storagePaths = null,
  }) {
    return _then(_value.copyWith(
      correspondents: null == correspondents
          ? _value.correspondents
          : correspondents // ignore: cast_nullable_to_non_nullable
              as Map<int, Correspondent>,
      documentTypes: null == documentTypes
          ? _value.documentTypes
          : documentTypes // ignore: cast_nullable_to_non_nullable
              as Map<int, DocumentType>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Map<int, Tag>,
      storagePaths: null == storagePaths
          ? _value.storagePaths
          : storagePaths // ignore: cast_nullable_to_non_nullable
              as Map<int, StoragePath>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LabelRepositoryStateCopyWith<$Res>
    implements $LabelRepositoryStateCopyWith<$Res> {
  factory _$$_LabelRepositoryStateCopyWith(_$_LabelRepositoryState value,
          $Res Function(_$_LabelRepositoryState) then) =
      __$$_LabelRepositoryStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<int, Correspondent> correspondents,
      Map<int, DocumentType> documentTypes,
      Map<int, Tag> tags,
      Map<int, StoragePath> storagePaths});
}

/// @nodoc
class __$$_LabelRepositoryStateCopyWithImpl<$Res>
    extends _$LabelRepositoryStateCopyWithImpl<$Res, _$_LabelRepositoryState>
    implements _$$_LabelRepositoryStateCopyWith<$Res> {
  __$$_LabelRepositoryStateCopyWithImpl(_$_LabelRepositoryState _value,
      $Res Function(_$_LabelRepositoryState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? correspondents = null,
    Object? documentTypes = null,
    Object? tags = null,
    Object? storagePaths = null,
  }) {
    return _then(_$_LabelRepositoryState(
      correspondents: null == correspondents
          ? _value._correspondents
          : correspondents // ignore: cast_nullable_to_non_nullable
              as Map<int, Correspondent>,
      documentTypes: null == documentTypes
          ? _value._documentTypes
          : documentTypes // ignore: cast_nullable_to_non_nullable
              as Map<int, DocumentType>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Map<int, Tag>,
      storagePaths: null == storagePaths
          ? _value._storagePaths
          : storagePaths // ignore: cast_nullable_to_non_nullable
              as Map<int, StoragePath>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LabelRepositoryState implements _LabelRepositoryState {
  const _$_LabelRepositoryState(
      {final Map<int, Correspondent> correspondents = const {},
      final Map<int, DocumentType> documentTypes = const {},
      final Map<int, Tag> tags = const {},
      final Map<int, StoragePath> storagePaths = const {}})
      : _correspondents = correspondents,
        _documentTypes = documentTypes,
        _tags = tags,
        _storagePaths = storagePaths;

  factory _$_LabelRepositoryState.fromJson(Map<String, dynamic> json) =>
      _$$_LabelRepositoryStateFromJson(json);

  final Map<int, Correspondent> _correspondents;
  @override
  @JsonKey()
  Map<int, Correspondent> get correspondents {
    if (_correspondents is EqualUnmodifiableMapView) return _correspondents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_correspondents);
  }

  final Map<int, DocumentType> _documentTypes;
  @override
  @JsonKey()
  Map<int, DocumentType> get documentTypes {
    if (_documentTypes is EqualUnmodifiableMapView) return _documentTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_documentTypes);
  }

  final Map<int, Tag> _tags;
  @override
  @JsonKey()
  Map<int, Tag> get tags {
    if (_tags is EqualUnmodifiableMapView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tags);
  }

  final Map<int, StoragePath> _storagePaths;
  @override
  @JsonKey()
  Map<int, StoragePath> get storagePaths {
    if (_storagePaths is EqualUnmodifiableMapView) return _storagePaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_storagePaths);
  }

  @override
  String toString() {
    return 'LabelRepositoryState(correspondents: $correspondents, documentTypes: $documentTypes, tags: $tags, storagePaths: $storagePaths)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LabelRepositoryState &&
            const DeepCollectionEquality()
                .equals(other._correspondents, _correspondents) &&
            const DeepCollectionEquality()
                .equals(other._documentTypes, _documentTypes) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._storagePaths, _storagePaths));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_correspondents),
      const DeepCollectionEquality().hash(_documentTypes),
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_storagePaths));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LabelRepositoryStateCopyWith<_$_LabelRepositoryState> get copyWith =>
      __$$_LabelRepositoryStateCopyWithImpl<_$_LabelRepositoryState>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LabelRepositoryStateToJson(
      this,
    );
  }
}

abstract class _LabelRepositoryState implements LabelRepositoryState {
  const factory _LabelRepositoryState(
      {final Map<int, Correspondent> correspondents,
      final Map<int, DocumentType> documentTypes,
      final Map<int, Tag> tags,
      final Map<int, StoragePath> storagePaths}) = _$_LabelRepositoryState;

  factory _LabelRepositoryState.fromJson(Map<String, dynamic> json) =
      _$_LabelRepositoryState.fromJson;

  @override
  Map<int, Correspondent> get correspondents;
  @override
  Map<int, DocumentType> get documentTypes;
  @override
  Map<int, Tag> get tags;
  @override
  Map<int, StoragePath> get storagePaths;
  @override
  @JsonKey(ignore: true)
  _$$_LabelRepositoryStateCopyWith<_$_LabelRepositoryState> get copyWith =>
      throw _privateConstructorUsedError;
}
