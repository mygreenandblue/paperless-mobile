// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'id_query_parameter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

IdQueryParameter _$IdQueryParameterFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'unset':
      return UnsetIdQueryParameter.fromJson(json);
    case 'notAssigned':
      return NotAssignedIdQueryParameter.fromJson(json);
    case 'anyAssigned':
      return AnyAssignedIdQueryParameter.fromJson(json);
    case 'fromId':
      return SetIdQueryParameter.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'IdQueryParameter',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$IdQueryParameter {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unset,
    required TResult Function() notAssigned,
    required TResult Function() anyAssigned,
    required TResult Function(@HiveField(0) int id) fromId,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unset,
    TResult? Function()? notAssigned,
    TResult? Function()? anyAssigned,
    TResult? Function(@HiveField(0) int id)? fromId,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unset,
    TResult Function()? notAssigned,
    TResult Function()? anyAssigned,
    TResult Function(@HiveField(0) int id)? fromId,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnsetIdQueryParameter value) unset,
    required TResult Function(NotAssignedIdQueryParameter value) notAssigned,
    required TResult Function(AnyAssignedIdQueryParameter value) anyAssigned,
    required TResult Function(SetIdQueryParameter value) fromId,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UnsetIdQueryParameter value)? unset,
    TResult? Function(NotAssignedIdQueryParameter value)? notAssigned,
    TResult? Function(AnyAssignedIdQueryParameter value)? anyAssigned,
    TResult? Function(SetIdQueryParameter value)? fromId,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnsetIdQueryParameter value)? unset,
    TResult Function(NotAssignedIdQueryParameter value)? notAssigned,
    TResult Function(AnyAssignedIdQueryParameter value)? anyAssigned,
    TResult Function(SetIdQueryParameter value)? fromId,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IdQueryParameterCopyWith<$Res> {
  factory $IdQueryParameterCopyWith(
          IdQueryParameter value, $Res Function(IdQueryParameter) then) =
      _$IdQueryParameterCopyWithImpl<$Res, IdQueryParameter>;
}

/// @nodoc
class _$IdQueryParameterCopyWithImpl<$Res, $Val extends IdQueryParameter>
    implements $IdQueryParameterCopyWith<$Res> {
  _$IdQueryParameterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$UnsetIdQueryParameterCopyWith<$Res> {
  factory _$$UnsetIdQueryParameterCopyWith(_$UnsetIdQueryParameter value,
          $Res Function(_$UnsetIdQueryParameter) then) =
      __$$UnsetIdQueryParameterCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnsetIdQueryParameterCopyWithImpl<$Res>
    extends _$IdQueryParameterCopyWithImpl<$Res, _$UnsetIdQueryParameter>
    implements _$$UnsetIdQueryParameterCopyWith<$Res> {
  __$$UnsetIdQueryParameterCopyWithImpl(_$UnsetIdQueryParameter _value,
      $Res Function(_$UnsetIdQueryParameter) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: PaperlessApiHiveTypeIds.unsetIdQueryParameter)
class _$UnsetIdQueryParameter extends UnsetIdQueryParameter {
  const _$UnsetIdQueryParameter({final String? $type})
      : $type = $type ?? 'unset',
        super._();

  factory _$UnsetIdQueryParameter.fromJson(Map<String, dynamic> json) =>
      _$$UnsetIdQueryParameterFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'IdQueryParameter.unset()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UnsetIdQueryParameter);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unset,
    required TResult Function() notAssigned,
    required TResult Function() anyAssigned,
    required TResult Function(@HiveField(0) int id) fromId,
  }) {
    return unset();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unset,
    TResult? Function()? notAssigned,
    TResult? Function()? anyAssigned,
    TResult? Function(@HiveField(0) int id)? fromId,
  }) {
    return unset?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unset,
    TResult Function()? notAssigned,
    TResult Function()? anyAssigned,
    TResult Function(@HiveField(0) int id)? fromId,
    required TResult orElse(),
  }) {
    if (unset != null) {
      return unset();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnsetIdQueryParameter value) unset,
    required TResult Function(NotAssignedIdQueryParameter value) notAssigned,
    required TResult Function(AnyAssignedIdQueryParameter value) anyAssigned,
    required TResult Function(SetIdQueryParameter value) fromId,
  }) {
    return unset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UnsetIdQueryParameter value)? unset,
    TResult? Function(NotAssignedIdQueryParameter value)? notAssigned,
    TResult? Function(AnyAssignedIdQueryParameter value)? anyAssigned,
    TResult? Function(SetIdQueryParameter value)? fromId,
  }) {
    return unset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnsetIdQueryParameter value)? unset,
    TResult Function(NotAssignedIdQueryParameter value)? notAssigned,
    TResult Function(AnyAssignedIdQueryParameter value)? anyAssigned,
    TResult Function(SetIdQueryParameter value)? fromId,
    required TResult orElse(),
  }) {
    if (unset != null) {
      return unset(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UnsetIdQueryParameterToJson(
      this,
    );
  }
}

abstract class UnsetIdQueryParameter extends IdQueryParameter {
  const factory UnsetIdQueryParameter() = _$UnsetIdQueryParameter;
  const UnsetIdQueryParameter._() : super._();

  factory UnsetIdQueryParameter.fromJson(Map<String, dynamic> json) =
      _$UnsetIdQueryParameter.fromJson;
}

/// @nodoc
abstract class _$$NotAssignedIdQueryParameterCopyWith<$Res> {
  factory _$$NotAssignedIdQueryParameterCopyWith(
          _$NotAssignedIdQueryParameter value,
          $Res Function(_$NotAssignedIdQueryParameter) then) =
      __$$NotAssignedIdQueryParameterCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NotAssignedIdQueryParameterCopyWithImpl<$Res>
    extends _$IdQueryParameterCopyWithImpl<$Res, _$NotAssignedIdQueryParameter>
    implements _$$NotAssignedIdQueryParameterCopyWith<$Res> {
  __$$NotAssignedIdQueryParameterCopyWithImpl(
      _$NotAssignedIdQueryParameter _value,
      $Res Function(_$NotAssignedIdQueryParameter) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: PaperlessApiHiveTypeIds.notAssignedIdQueryParameter)
class _$NotAssignedIdQueryParameter extends NotAssignedIdQueryParameter {
  const _$NotAssignedIdQueryParameter({final String? $type})
      : $type = $type ?? 'notAssigned',
        super._();

  factory _$NotAssignedIdQueryParameter.fromJson(Map<String, dynamic> json) =>
      _$$NotAssignedIdQueryParameterFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'IdQueryParameter.notAssigned()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotAssignedIdQueryParameter);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unset,
    required TResult Function() notAssigned,
    required TResult Function() anyAssigned,
    required TResult Function(@HiveField(0) int id) fromId,
  }) {
    return notAssigned();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unset,
    TResult? Function()? notAssigned,
    TResult? Function()? anyAssigned,
    TResult? Function(@HiveField(0) int id)? fromId,
  }) {
    return notAssigned?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unset,
    TResult Function()? notAssigned,
    TResult Function()? anyAssigned,
    TResult Function(@HiveField(0) int id)? fromId,
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
    required TResult Function(UnsetIdQueryParameter value) unset,
    required TResult Function(NotAssignedIdQueryParameter value) notAssigned,
    required TResult Function(AnyAssignedIdQueryParameter value) anyAssigned,
    required TResult Function(SetIdQueryParameter value) fromId,
  }) {
    return notAssigned(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UnsetIdQueryParameter value)? unset,
    TResult? Function(NotAssignedIdQueryParameter value)? notAssigned,
    TResult? Function(AnyAssignedIdQueryParameter value)? anyAssigned,
    TResult? Function(SetIdQueryParameter value)? fromId,
  }) {
    return notAssigned?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnsetIdQueryParameter value)? unset,
    TResult Function(NotAssignedIdQueryParameter value)? notAssigned,
    TResult Function(AnyAssignedIdQueryParameter value)? anyAssigned,
    TResult Function(SetIdQueryParameter value)? fromId,
    required TResult orElse(),
  }) {
    if (notAssigned != null) {
      return notAssigned(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NotAssignedIdQueryParameterToJson(
      this,
    );
  }
}

abstract class NotAssignedIdQueryParameter extends IdQueryParameter {
  const factory NotAssignedIdQueryParameter() = _$NotAssignedIdQueryParameter;
  const NotAssignedIdQueryParameter._() : super._();

  factory NotAssignedIdQueryParameter.fromJson(Map<String, dynamic> json) =
      _$NotAssignedIdQueryParameter.fromJson;
}

/// @nodoc
abstract class _$$AnyAssignedIdQueryParameterCopyWith<$Res> {
  factory _$$AnyAssignedIdQueryParameterCopyWith(
          _$AnyAssignedIdQueryParameter value,
          $Res Function(_$AnyAssignedIdQueryParameter) then) =
      __$$AnyAssignedIdQueryParameterCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnyAssignedIdQueryParameterCopyWithImpl<$Res>
    extends _$IdQueryParameterCopyWithImpl<$Res, _$AnyAssignedIdQueryParameter>
    implements _$$AnyAssignedIdQueryParameterCopyWith<$Res> {
  __$$AnyAssignedIdQueryParameterCopyWithImpl(
      _$AnyAssignedIdQueryParameter _value,
      $Res Function(_$AnyAssignedIdQueryParameter) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: PaperlessApiHiveTypeIds.anyAssignedIdQueryParameter)
class _$AnyAssignedIdQueryParameter extends AnyAssignedIdQueryParameter {
  const _$AnyAssignedIdQueryParameter({final String? $type})
      : $type = $type ?? 'anyAssigned',
        super._();

  factory _$AnyAssignedIdQueryParameter.fromJson(Map<String, dynamic> json) =>
      _$$AnyAssignedIdQueryParameterFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'IdQueryParameter.anyAssigned()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnyAssignedIdQueryParameter);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unset,
    required TResult Function() notAssigned,
    required TResult Function() anyAssigned,
    required TResult Function(@HiveField(0) int id) fromId,
  }) {
    return anyAssigned();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unset,
    TResult? Function()? notAssigned,
    TResult? Function()? anyAssigned,
    TResult? Function(@HiveField(0) int id)? fromId,
  }) {
    return anyAssigned?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unset,
    TResult Function()? notAssigned,
    TResult Function()? anyAssigned,
    TResult Function(@HiveField(0) int id)? fromId,
    required TResult orElse(),
  }) {
    if (anyAssigned != null) {
      return anyAssigned();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnsetIdQueryParameter value) unset,
    required TResult Function(NotAssignedIdQueryParameter value) notAssigned,
    required TResult Function(AnyAssignedIdQueryParameter value) anyAssigned,
    required TResult Function(SetIdQueryParameter value) fromId,
  }) {
    return anyAssigned(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UnsetIdQueryParameter value)? unset,
    TResult? Function(NotAssignedIdQueryParameter value)? notAssigned,
    TResult? Function(AnyAssignedIdQueryParameter value)? anyAssigned,
    TResult? Function(SetIdQueryParameter value)? fromId,
  }) {
    return anyAssigned?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnsetIdQueryParameter value)? unset,
    TResult Function(NotAssignedIdQueryParameter value)? notAssigned,
    TResult Function(AnyAssignedIdQueryParameter value)? anyAssigned,
    TResult Function(SetIdQueryParameter value)? fromId,
    required TResult orElse(),
  }) {
    if (anyAssigned != null) {
      return anyAssigned(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AnyAssignedIdQueryParameterToJson(
      this,
    );
  }
}

abstract class AnyAssignedIdQueryParameter extends IdQueryParameter {
  const factory AnyAssignedIdQueryParameter() = _$AnyAssignedIdQueryParameter;
  const AnyAssignedIdQueryParameter._() : super._();

  factory AnyAssignedIdQueryParameter.fromJson(Map<String, dynamic> json) =
      _$AnyAssignedIdQueryParameter.fromJson;
}

/// @nodoc
abstract class _$$SetIdQueryParameterCopyWith<$Res> {
  factory _$$SetIdQueryParameterCopyWith(_$SetIdQueryParameter value,
          $Res Function(_$SetIdQueryParameter) then) =
      __$$SetIdQueryParameterCopyWithImpl<$Res>;
  @useResult
  $Res call({@HiveField(0) int id});
}

/// @nodoc
class __$$SetIdQueryParameterCopyWithImpl<$Res>
    extends _$IdQueryParameterCopyWithImpl<$Res, _$SetIdQueryParameter>
    implements _$$SetIdQueryParameterCopyWith<$Res> {
  __$$SetIdQueryParameterCopyWithImpl(
      _$SetIdQueryParameter _value, $Res Function(_$SetIdQueryParameter) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_$SetIdQueryParameter(
      null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: PaperlessApiHiveTypeIds.setIdQueryParameter)
class _$SetIdQueryParameter extends SetIdQueryParameter {
  const _$SetIdQueryParameter(@HiveField(0) this.id, {final String? $type})
      : $type = $type ?? 'fromId',
        super._();

  factory _$SetIdQueryParameter.fromJson(Map<String, dynamic> json) =>
      _$$SetIdQueryParameterFromJson(json);

  @override
  @HiveField(0)
  final int id;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'IdQueryParameter.fromId(id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetIdQueryParameter &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SetIdQueryParameterCopyWith<_$SetIdQueryParameter> get copyWith =>
      __$$SetIdQueryParameterCopyWithImpl<_$SetIdQueryParameter>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unset,
    required TResult Function() notAssigned,
    required TResult Function() anyAssigned,
    required TResult Function(@HiveField(0) int id) fromId,
  }) {
    return fromId(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unset,
    TResult? Function()? notAssigned,
    TResult? Function()? anyAssigned,
    TResult? Function(@HiveField(0) int id)? fromId,
  }) {
    return fromId?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unset,
    TResult Function()? notAssigned,
    TResult Function()? anyAssigned,
    TResult Function(@HiveField(0) int id)? fromId,
    required TResult orElse(),
  }) {
    if (fromId != null) {
      return fromId(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnsetIdQueryParameter value) unset,
    required TResult Function(NotAssignedIdQueryParameter value) notAssigned,
    required TResult Function(AnyAssignedIdQueryParameter value) anyAssigned,
    required TResult Function(SetIdQueryParameter value) fromId,
  }) {
    return fromId(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UnsetIdQueryParameter value)? unset,
    TResult? Function(NotAssignedIdQueryParameter value)? notAssigned,
    TResult? Function(AnyAssignedIdQueryParameter value)? anyAssigned,
    TResult? Function(SetIdQueryParameter value)? fromId,
  }) {
    return fromId?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnsetIdQueryParameter value)? unset,
    TResult Function(NotAssignedIdQueryParameter value)? notAssigned,
    TResult Function(AnyAssignedIdQueryParameter value)? anyAssigned,
    TResult Function(SetIdQueryParameter value)? fromId,
    required TResult orElse(),
  }) {
    if (fromId != null) {
      return fromId(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SetIdQueryParameterToJson(
      this,
    );
  }
}

abstract class SetIdQueryParameter extends IdQueryParameter {
  const factory SetIdQueryParameter(@HiveField(0) final int id) =
      _$SetIdQueryParameter;
  const SetIdQueryParameter._() : super._();

  factory SetIdQueryParameter.fromJson(Map<String, dynamic> json) =
      _$SetIdQueryParameter.fromJson;

  @HiveField(0)
  int get id;
  @JsonKey(ignore: true)
  _$$SetIdQueryParameterCopyWith<_$SetIdQueryParameter> get copyWith =>
      throw _privateConstructorUsedError;
}
