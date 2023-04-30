// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permissions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Permissions _$PermissionsFromJson(Map<String, dynamic> json) {
  return _Permissions.fromJson(json);
}

/// @nodoc
mixin _$Permissions {
  @HiveField(0)
  List<int> get view => throw _privateConstructorUsedError;
  @HiveField(1)
  List<int> get change => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PermissionsCopyWith<Permissions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionsCopyWith<$Res> {
  factory $PermissionsCopyWith(
          Permissions value, $Res Function(Permissions) then) =
      _$PermissionsCopyWithImpl<$Res, Permissions>;
  @useResult
  $Res call({@HiveField(0) List<int> view, @HiveField(1) List<int> change});
}

/// @nodoc
class _$PermissionsCopyWithImpl<$Res, $Val extends Permissions>
    implements $PermissionsCopyWith<$Res> {
  _$PermissionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? view = null,
    Object? change = null,
  }) {
    return _then(_value.copyWith(
      view: null == view
          ? _value.view
          : view // ignore: cast_nullable_to_non_nullable
              as List<int>,
      change: null == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PermissionsCopyWith<$Res>
    implements $PermissionsCopyWith<$Res> {
  factory _$$_PermissionsCopyWith(
          _$_Permissions value, $Res Function(_$_Permissions) then) =
      __$$_PermissionsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@HiveField(0) List<int> view, @HiveField(1) List<int> change});
}

/// @nodoc
class __$$_PermissionsCopyWithImpl<$Res>
    extends _$PermissionsCopyWithImpl<$Res, _$_Permissions>
    implements _$$_PermissionsCopyWith<$Res> {
  __$$_PermissionsCopyWithImpl(
      _$_Permissions _value, $Res Function(_$_Permissions) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? view = null,
    Object? change = null,
  }) {
    return _then(_$_Permissions(
      view: null == view
          ? _value._view
          : view // ignore: cast_nullable_to_non_nullable
              as List<int>,
      change: null == change
          ? _value._change
          : change // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Permissions implements _Permissions {
  const _$_Permissions(
      {@HiveField(0) final List<int> view = const [],
      @HiveField(1) final List<int> change = const []})
      : _view = view,
        _change = change;

  factory _$_Permissions.fromJson(Map<String, dynamic> json) =>
      _$$_PermissionsFromJson(json);

  final List<int> _view;
  @override
  @JsonKey()
  @HiveField(0)
  List<int> get view {
    if (_view is EqualUnmodifiableListView) return _view;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_view);
  }

  final List<int> _change;
  @override
  @JsonKey()
  @HiveField(1)
  List<int> get change {
    if (_change is EqualUnmodifiableListView) return _change;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_change);
  }

  @override
  String toString() {
    return 'Permissions(view: $view, change: $change)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Permissions &&
            const DeepCollectionEquality().equals(other._view, _view) &&
            const DeepCollectionEquality().equals(other._change, _change));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_view),
      const DeepCollectionEquality().hash(_change));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PermissionsCopyWith<_$_Permissions> get copyWith =>
      __$$_PermissionsCopyWithImpl<_$_Permissions>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PermissionsToJson(
      this,
    );
  }
}

abstract class _Permissions implements Permissions {
  const factory _Permissions(
      {@HiveField(0) final List<int> view,
      @HiveField(1) final List<int> change}) = _$_Permissions;

  factory _Permissions.fromJson(Map<String, dynamic> json) =
      _$_Permissions.fromJson;

  @override
  @HiveField(0)
  List<int> get view;
  @override
  @HiveField(1)
  List<int> get change;
  @override
  @JsonKey(ignore: true)
  _$$_PermissionsCopyWith<_$_Permissions> get copyWith =>
      throw _privateConstructorUsedError;
}
