// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tags_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TagsQuery _$TagsQueryFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'notAssigned':
      return NotAssignedTagsQuery.fromJson(json);
    case 'anyAssigned':
      return AnyAssignedTagsQuery.fromJson(json);
    case 'ids':
      return IdsTagsQuery.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'TagsQuery',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$TagsQuery {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notAssigned,
    required TResult Function(List<int> tagIds) anyAssigned,
    required TResult Function(List<int> include, List<int> exclude) ids,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? notAssigned,
    TResult? Function(List<int> tagIds)? anyAssigned,
    TResult? Function(List<int> include, List<int> exclude)? ids,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notAssigned,
    TResult Function(List<int> tagIds)? anyAssigned,
    TResult Function(List<int> include, List<int> exclude)? ids,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NotAssignedTagsQuery value) notAssigned,
    required TResult Function(AnyAssignedTagsQuery value) anyAssigned,
    required TResult Function(IdsTagsQuery value) ids,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotAssignedTagsQuery value)? notAssigned,
    TResult? Function(AnyAssignedTagsQuery value)? anyAssigned,
    TResult? Function(IdsTagsQuery value)? ids,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotAssignedTagsQuery value)? notAssigned,
    TResult Function(AnyAssignedTagsQuery value)? anyAssigned,
    TResult Function(IdsTagsQuery value)? ids,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagsQueryCopyWith<$Res> {
  factory $TagsQueryCopyWith(TagsQuery value, $Res Function(TagsQuery) then) =
      _$TagsQueryCopyWithImpl<$Res, TagsQuery>;
}

/// @nodoc
class _$TagsQueryCopyWithImpl<$Res, $Val extends TagsQuery>
    implements $TagsQueryCopyWith<$Res> {
  _$TagsQueryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$NotAssignedTagsQueryCopyWith<$Res> {
  factory _$$NotAssignedTagsQueryCopyWith(_$NotAssignedTagsQuery value,
          $Res Function(_$NotAssignedTagsQuery) then) =
      __$$NotAssignedTagsQueryCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NotAssignedTagsQueryCopyWithImpl<$Res>
    extends _$TagsQueryCopyWithImpl<$Res, _$NotAssignedTagsQuery>
    implements _$$NotAssignedTagsQueryCopyWith<$Res> {
  __$$NotAssignedTagsQueryCopyWithImpl(_$NotAssignedTagsQuery _value,
      $Res Function(_$NotAssignedTagsQuery) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: PaperlessApiHiveTypeIds.notAssignedTagsQuery)
class _$NotAssignedTagsQuery extends NotAssignedTagsQuery {
  const _$NotAssignedTagsQuery({final String? $type})
      : $type = $type ?? 'notAssigned',
        super._();

  factory _$NotAssignedTagsQuery.fromJson(Map<String, dynamic> json) =>
      _$$NotAssignedTagsQueryFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TagsQuery.notAssigned()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NotAssignedTagsQuery);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notAssigned,
    required TResult Function(List<int> tagIds) anyAssigned,
    required TResult Function(List<int> include, List<int> exclude) ids,
  }) {
    return notAssigned();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? notAssigned,
    TResult? Function(List<int> tagIds)? anyAssigned,
    TResult? Function(List<int> include, List<int> exclude)? ids,
  }) {
    return notAssigned?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notAssigned,
    TResult Function(List<int> tagIds)? anyAssigned,
    TResult Function(List<int> include, List<int> exclude)? ids,
    required TResult orElse(),
  }) {
    if (notAssigned != null) {
      return notAssigned();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NotAssignedTagsQuery value) notAssigned,
    required TResult Function(AnyAssignedTagsQuery value) anyAssigned,
    required TResult Function(IdsTagsQuery value) ids,
  }) {
    return notAssigned(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotAssignedTagsQuery value)? notAssigned,
    TResult? Function(AnyAssignedTagsQuery value)? anyAssigned,
    TResult? Function(IdsTagsQuery value)? ids,
  }) {
    return notAssigned?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotAssignedTagsQuery value)? notAssigned,
    TResult Function(AnyAssignedTagsQuery value)? anyAssigned,
    TResult Function(IdsTagsQuery value)? ids,
    required TResult orElse(),
  }) {
    if (notAssigned != null) {
      return notAssigned(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NotAssignedTagsQueryToJson(
      this,
    );
  }
}

abstract class NotAssignedTagsQuery extends TagsQuery {
  const factory NotAssignedTagsQuery() = _$NotAssignedTagsQuery;
  const NotAssignedTagsQuery._() : super._();

  factory NotAssignedTagsQuery.fromJson(Map<String, dynamic> json) =
      _$NotAssignedTagsQuery.fromJson;
}

/// @nodoc
abstract class _$$AnyAssignedTagsQueryCopyWith<$Res> {
  factory _$$AnyAssignedTagsQueryCopyWith(_$AnyAssignedTagsQuery value,
          $Res Function(_$AnyAssignedTagsQuery) then) =
      __$$AnyAssignedTagsQueryCopyWithImpl<$Res>;
  @useResult
  $Res call({List<int> tagIds});
}

/// @nodoc
class __$$AnyAssignedTagsQueryCopyWithImpl<$Res>
    extends _$TagsQueryCopyWithImpl<$Res, _$AnyAssignedTagsQuery>
    implements _$$AnyAssignedTagsQueryCopyWith<$Res> {
  __$$AnyAssignedTagsQueryCopyWithImpl(_$AnyAssignedTagsQuery _value,
      $Res Function(_$AnyAssignedTagsQuery) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tagIds = null,
  }) {
    return _then(_$AnyAssignedTagsQuery(
      tagIds: null == tagIds
          ? _value._tagIds
          : tagIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: PaperlessApiHiveTypeIds.anyAssignedTagsQuery)
class _$AnyAssignedTagsQuery extends AnyAssignedTagsQuery {
  const _$AnyAssignedTagsQuery(
      {final List<int> tagIds = const [], final String? $type})
      : _tagIds = tagIds,
        $type = $type ?? 'anyAssigned',
        super._();

  factory _$AnyAssignedTagsQuery.fromJson(Map<String, dynamic> json) =>
      _$$AnyAssignedTagsQueryFromJson(json);

  final List<int> _tagIds;
  @override
  @JsonKey()
  List<int> get tagIds {
    if (_tagIds is EqualUnmodifiableListView) return _tagIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagIds);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TagsQuery.anyAssigned(tagIds: $tagIds)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnyAssignedTagsQuery &&
            const DeepCollectionEquality().equals(other._tagIds, _tagIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_tagIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnyAssignedTagsQueryCopyWith<_$AnyAssignedTagsQuery> get copyWith =>
      __$$AnyAssignedTagsQueryCopyWithImpl<_$AnyAssignedTagsQuery>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notAssigned,
    required TResult Function(List<int> tagIds) anyAssigned,
    required TResult Function(List<int> include, List<int> exclude) ids,
  }) {
    return anyAssigned(tagIds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? notAssigned,
    TResult? Function(List<int> tagIds)? anyAssigned,
    TResult? Function(List<int> include, List<int> exclude)? ids,
  }) {
    return anyAssigned?.call(tagIds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notAssigned,
    TResult Function(List<int> tagIds)? anyAssigned,
    TResult Function(List<int> include, List<int> exclude)? ids,
    required TResult orElse(),
  }) {
    if (anyAssigned != null) {
      return anyAssigned(tagIds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NotAssignedTagsQuery value) notAssigned,
    required TResult Function(AnyAssignedTagsQuery value) anyAssigned,
    required TResult Function(IdsTagsQuery value) ids,
  }) {
    return anyAssigned(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotAssignedTagsQuery value)? notAssigned,
    TResult? Function(AnyAssignedTagsQuery value)? anyAssigned,
    TResult? Function(IdsTagsQuery value)? ids,
  }) {
    return anyAssigned?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotAssignedTagsQuery value)? notAssigned,
    TResult Function(AnyAssignedTagsQuery value)? anyAssigned,
    TResult Function(IdsTagsQuery value)? ids,
    required TResult orElse(),
  }) {
    if (anyAssigned != null) {
      return anyAssigned(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AnyAssignedTagsQueryToJson(
      this,
    );
  }
}

abstract class AnyAssignedTagsQuery extends TagsQuery {
  const factory AnyAssignedTagsQuery({final List<int> tagIds}) =
      _$AnyAssignedTagsQuery;
  const AnyAssignedTagsQuery._() : super._();

  factory AnyAssignedTagsQuery.fromJson(Map<String, dynamic> json) =
      _$AnyAssignedTagsQuery.fromJson;

  List<int> get tagIds;
  @JsonKey(ignore: true)
  _$$AnyAssignedTagsQueryCopyWith<_$AnyAssignedTagsQuery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IdsTagsQueryCopyWith<$Res> {
  factory _$$IdsTagsQueryCopyWith(
          _$IdsTagsQuery value, $Res Function(_$IdsTagsQuery) then) =
      __$$IdsTagsQueryCopyWithImpl<$Res>;
  @useResult
  $Res call({List<int> include, List<int> exclude});
}

/// @nodoc
class __$$IdsTagsQueryCopyWithImpl<$Res>
    extends _$TagsQueryCopyWithImpl<$Res, _$IdsTagsQuery>
    implements _$$IdsTagsQueryCopyWith<$Res> {
  __$$IdsTagsQueryCopyWithImpl(
      _$IdsTagsQuery _value, $Res Function(_$IdsTagsQuery) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? include = null,
    Object? exclude = null,
  }) {
    return _then(_$IdsTagsQuery(
      include: null == include
          ? _value._include
          : include // ignore: cast_nullable_to_non_nullable
              as List<int>,
      exclude: null == exclude
          ? _value._exclude
          : exclude // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: PaperlessApiHiveTypeIds.idsTagsQuery)
class _$IdsTagsQuery extends IdsTagsQuery {
  const _$IdsTagsQuery(
      {final List<int> include = const [],
      final List<int> exclude = const [],
      final String? $type})
      : _include = include,
        _exclude = exclude,
        $type = $type ?? 'ids',
        super._();

  factory _$IdsTagsQuery.fromJson(Map<String, dynamic> json) =>
      _$$IdsTagsQueryFromJson(json);

  final List<int> _include;
  @override
  @JsonKey()
  List<int> get include {
    if (_include is EqualUnmodifiableListView) return _include;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_include);
  }

  final List<int> _exclude;
  @override
  @JsonKey()
  List<int> get exclude {
    if (_exclude is EqualUnmodifiableListView) return _exclude;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exclude);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TagsQuery.ids(include: $include, exclude: $exclude)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IdsTagsQuery &&
            const DeepCollectionEquality().equals(other._include, _include) &&
            const DeepCollectionEquality().equals(other._exclude, _exclude));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_include),
      const DeepCollectionEquality().hash(_exclude));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IdsTagsQueryCopyWith<_$IdsTagsQuery> get copyWith =>
      __$$IdsTagsQueryCopyWithImpl<_$IdsTagsQuery>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notAssigned,
    required TResult Function(List<int> tagIds) anyAssigned,
    required TResult Function(List<int> include, List<int> exclude) ids,
  }) {
    return ids(include, exclude);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? notAssigned,
    TResult? Function(List<int> tagIds)? anyAssigned,
    TResult? Function(List<int> include, List<int> exclude)? ids,
  }) {
    return ids?.call(include, exclude);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notAssigned,
    TResult Function(List<int> tagIds)? anyAssigned,
    TResult Function(List<int> include, List<int> exclude)? ids,
    required TResult orElse(),
  }) {
    if (ids != null) {
      return ids(include, exclude);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NotAssignedTagsQuery value) notAssigned,
    required TResult Function(AnyAssignedTagsQuery value) anyAssigned,
    required TResult Function(IdsTagsQuery value) ids,
  }) {
    return ids(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotAssignedTagsQuery value)? notAssigned,
    TResult? Function(AnyAssignedTagsQuery value)? anyAssigned,
    TResult? Function(IdsTagsQuery value)? ids,
  }) {
    return ids?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotAssignedTagsQuery value)? notAssigned,
    TResult Function(AnyAssignedTagsQuery value)? anyAssigned,
    TResult Function(IdsTagsQuery value)? ids,
    required TResult orElse(),
  }) {
    if (ids != null) {
      return ids(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IdsTagsQueryToJson(
      this,
    );
  }
}

abstract class IdsTagsQuery extends TagsQuery {
  const factory IdsTagsQuery(
      {final List<int> include, final List<int> exclude}) = _$IdsTagsQuery;
  const IdsTagsQuery._() : super._();

  factory IdsTagsQuery.fromJson(Map<String, dynamic> json) =
      _$IdsTagsQuery.fromJson;

  List<int> get include;
  List<int> get exclude;
  @JsonKey(ignore: true)
  _$$IdsTagsQueryCopyWith<_$IdsTagsQuery> get copyWith =>
      throw _privateConstructorUsedError;
}
