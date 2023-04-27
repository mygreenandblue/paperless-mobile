// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'label_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LabelState {
  Map<int, Correspondent> get correspondents =>
      throw _privateConstructorUsedError;
  Map<int, DocumentType> get documentTypes =>
      throw _privateConstructorUsedError;
  Map<int, Tag> get tags => throw _privateConstructorUsedError;
  Map<int, StoragePath> get storagePaths => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LabelStateCopyWith<LabelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabelStateCopyWith<$Res> {
  factory $LabelStateCopyWith(
          LabelState value, $Res Function(LabelState) then) =
      _$LabelStateCopyWithImpl<$Res, LabelState>;
  @useResult
  $Res call(
      {Map<int, Correspondent> correspondents,
      Map<int, DocumentType> documentTypes,
      Map<int, Tag> tags,
      Map<int, StoragePath> storagePaths});
}

/// @nodoc
class _$LabelStateCopyWithImpl<$Res, $Val extends LabelState>
    implements $LabelStateCopyWith<$Res> {
  _$LabelStateCopyWithImpl(this._value, this._then);

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
abstract class _$$_LabelStateCopyWith<$Res>
    implements $LabelStateCopyWith<$Res> {
  factory _$$_LabelStateCopyWith(
          _$_LabelState value, $Res Function(_$_LabelState) then) =
      __$$_LabelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<int, Correspondent> correspondents,
      Map<int, DocumentType> documentTypes,
      Map<int, Tag> tags,
      Map<int, StoragePath> storagePaths});
}

/// @nodoc
class __$$_LabelStateCopyWithImpl<$Res>
    extends _$LabelStateCopyWithImpl<$Res, _$_LabelState>
    implements _$$_LabelStateCopyWith<$Res> {
  __$$_LabelStateCopyWithImpl(
      _$_LabelState _value, $Res Function(_$_LabelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? correspondents = null,
    Object? documentTypes = null,
    Object? tags = null,
    Object? storagePaths = null,
  }) {
    return _then(_$_LabelState(
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

class _$_LabelState implements _LabelState {
  const _$_LabelState(
      {final Map<int, Correspondent> correspondents = const {},
      final Map<int, DocumentType> documentTypes = const {},
      final Map<int, Tag> tags = const {},
      final Map<int, StoragePath> storagePaths = const {}})
      : _correspondents = correspondents,
        _documentTypes = documentTypes,
        _tags = tags,
        _storagePaths = storagePaths;

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
    return 'LabelState(correspondents: $correspondents, documentTypes: $documentTypes, tags: $tags, storagePaths: $storagePaths)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LabelState &&
            const DeepCollectionEquality()
                .equals(other._correspondents, _correspondents) &&
            const DeepCollectionEquality()
                .equals(other._documentTypes, _documentTypes) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._storagePaths, _storagePaths));
  }

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
  _$$_LabelStateCopyWith<_$_LabelState> get copyWith =>
      __$$_LabelStateCopyWithImpl<_$_LabelState>(this, _$identity);
}

abstract class _LabelState implements LabelState {
  const factory _LabelState(
      {final Map<int, Correspondent> correspondents,
      final Map<int, DocumentType> documentTypes,
      final Map<int, Tag> tags,
      final Map<int, StoragePath> storagePaths}) = _$_LabelState;

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
  _$$_LabelStateCopyWith<_$_LabelState> get copyWith =>
      throw _privateConstructorUsedError;
}
