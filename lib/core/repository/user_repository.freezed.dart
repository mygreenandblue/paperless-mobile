// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserRepositoryState _$UserRepositoryStateFromJson(Map<String, dynamic> json) {
  return _UserRepositoryState.fromJson(json);
}

/// @nodoc
mixin _$UserRepositoryState {
  Map<int, UserModel> get users => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserRepositoryStateCopyWith<UserRepositoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRepositoryStateCopyWith<$Res> {
  factory $UserRepositoryStateCopyWith(
          UserRepositoryState value, $Res Function(UserRepositoryState) then) =
      _$UserRepositoryStateCopyWithImpl<$Res, UserRepositoryState>;
  @useResult
  $Res call({Map<int, UserModel> users});
}

/// @nodoc
class _$UserRepositoryStateCopyWithImpl<$Res, $Val extends UserRepositoryState>
    implements $UserRepositoryStateCopyWith<$Res> {
  _$UserRepositoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
  }) {
    return _then(_value.copyWith(
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as Map<int, UserModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserRepositoryStateCopyWith<$Res>
    implements $UserRepositoryStateCopyWith<$Res> {
  factory _$$_UserRepositoryStateCopyWith(_$_UserRepositoryState value,
          $Res Function(_$_UserRepositoryState) then) =
      __$$_UserRepositoryStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<int, UserModel> users});
}

/// @nodoc
class __$$_UserRepositoryStateCopyWithImpl<$Res>
    extends _$UserRepositoryStateCopyWithImpl<$Res, _$_UserRepositoryState>
    implements _$$_UserRepositoryStateCopyWith<$Res> {
  __$$_UserRepositoryStateCopyWithImpl(_$_UserRepositoryState _value,
      $Res Function(_$_UserRepositoryState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
  }) {
    return _then(_$_UserRepositoryState(
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as Map<int, UserModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserRepositoryState implements _UserRepositoryState {
  const _$_UserRepositoryState({final Map<int, UserModel> users = const {}})
      : _users = users;

  factory _$_UserRepositoryState.fromJson(Map<String, dynamic> json) =>
      _$$_UserRepositoryStateFromJson(json);

  final Map<int, UserModel> _users;
  @override
  @JsonKey()
  Map<int, UserModel> get users {
    if (_users is EqualUnmodifiableMapView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_users);
  }

  @override
  String toString() {
    return 'UserRepositoryState(users: $users)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserRepositoryState &&
            const DeepCollectionEquality().equals(other._users, _users));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_users));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserRepositoryStateCopyWith<_$_UserRepositoryState> get copyWith =>
      __$$_UserRepositoryStateCopyWithImpl<_$_UserRepositoryState>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserRepositoryStateToJson(
      this,
    );
  }
}

abstract class _UserRepositoryState implements UserRepositoryState {
  const factory _UserRepositoryState({final Map<int, UserModel> users}) =
      _$_UserRepositoryState;

  factory _UserRepositoryState.fromJson(Map<String, dynamic> json) =
      _$_UserRepositoryState.fromJson;

  @override
  Map<int, UserModel> get users;
  @override
  @JsonKey(ignore: true)
  _$$_UserRepositoryStateCopyWith<_$_UserRepositoryState> get copyWith =>
      throw _privateConstructorUsedError;
}
