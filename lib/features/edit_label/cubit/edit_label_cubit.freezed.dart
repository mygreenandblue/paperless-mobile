// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_label_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$EditLabelState {
  Map<int, Correspondent> get correspondents =>
      throw _privateConstructorUsedError;
  Map<int, DocumentType> get documentTypes =>
      throw _privateConstructorUsedError;
  Map<int, Tag> get tags => throw _privateConstructorUsedError;
  Map<int, StoragePath> get storagePaths => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EditLabelStateCopyWith<EditLabelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditLabelStateCopyWith<$Res> {
  factory $EditLabelStateCopyWith(
          EditLabelState value, $Res Function(EditLabelState) then) =
      _$EditLabelStateCopyWithImpl<$Res, EditLabelState>;
  @useResult
  $Res call(
      {Map<int, Correspondent> correspondents,
      Map<int, DocumentType> documentTypes,
      Map<int, Tag> tags,
      Map<int, StoragePath> storagePaths});
}

/// @nodoc
class _$EditLabelStateCopyWithImpl<$Res, $Val extends EditLabelState>
    implements $EditLabelStateCopyWith<$Res> {
  _$EditLabelStateCopyWithImpl(this._value, this._then);

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
abstract class _$$_EditLabelStateCopyWith<$Res>
    implements $EditLabelStateCopyWith<$Res> {
  factory _$$_EditLabelStateCopyWith(
          _$_EditLabelState value, $Res Function(_$_EditLabelState) then) =
      __$$_EditLabelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<int, Correspondent> correspondents,
      Map<int, DocumentType> documentTypes,
      Map<int, Tag> tags,
      Map<int, StoragePath> storagePaths});
}

/// @nodoc
class __$$_EditLabelStateCopyWithImpl<$Res>
    extends _$EditLabelStateCopyWithImpl<$Res, _$_EditLabelState>
    implements _$$_EditLabelStateCopyWith<$Res> {
  __$$_EditLabelStateCopyWithImpl(
      _$_EditLabelState _value, $Res Function(_$_EditLabelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? correspondents = null,
    Object? documentTypes = null,
    Object? tags = null,
    Object? storagePaths = null,
  }) {
    return _then(_$_EditLabelState(
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

class _$_EditLabelState implements _EditLabelState {
  const _$_EditLabelState(
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
    return 'EditLabelState(correspondents: $correspondents, documentTypes: $documentTypes, tags: $tags, storagePaths: $storagePaths)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EditLabelState &&
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
  _$$_EditLabelStateCopyWith<_$_EditLabelState> get copyWith =>
      __$$_EditLabelStateCopyWithImpl<_$_EditLabelState>(this, _$identity);
}

abstract class _EditLabelState implements EditLabelState {
  const factory _EditLabelState(
      {final Map<int, Correspondent> correspondents,
      final Map<int, DocumentType> documentTypes,
      final Map<int, Tag> tags,
      final Map<int, StoragePath> storagePaths}) = _$_EditLabelState;

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
  _$$_EditLabelStateCopyWith<_$_EditLabelState> get copyWith =>
      throw _privateConstructorUsedError;
}
