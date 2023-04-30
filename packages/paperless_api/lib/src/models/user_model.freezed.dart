// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'v3':
      return UserModelV3.fromJson(json);
    case 'v2':
      return UserModelV2.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'UserModel',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$UserModel {
  @HiveField(0)
  int get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get username => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @HiveField(0) int id,
            @HiveField(1) String username,
            @HiveField(2) String email,
            @HiveField(3) String? firstName,
            @HiveField(4) String? lastName,
            @HiveField(5) DateTime? dateJoined,
            @HiveField(6) bool isStaff,
            @HiveField(7) bool isActive,
            @HiveField(8) bool isSuperuser,
            @HiveField(9) List<int> groups,
            @HiveField(10) List<UserPermissions> userPermissions,
            @HiveField(11) List<InheritedPermissions> inheritedPermissions)
        v3,
    required TResult Function(@HiveField(0) @JsonKey(name: "user_id") int id,
            @HiveField(1) String username, @HiveField(2) String? displayName)
        v2,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @HiveField(0) int id,
            @HiveField(1) String username,
            @HiveField(2) String email,
            @HiveField(3) String? firstName,
            @HiveField(4) String? lastName,
            @HiveField(5) DateTime? dateJoined,
            @HiveField(6) bool isStaff,
            @HiveField(7) bool isActive,
            @HiveField(8) bool isSuperuser,
            @HiveField(9) List<int> groups,
            @HiveField(10) List<UserPermissions> userPermissions,
            @HiveField(11) List<InheritedPermissions> inheritedPermissions)?
        v3,
    TResult? Function(@HiveField(0) @JsonKey(name: "user_id") int id,
            @HiveField(1) String username, @HiveField(2) String? displayName)?
        v2,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @HiveField(0) int id,
            @HiveField(1) String username,
            @HiveField(2) String email,
            @HiveField(3) String? firstName,
            @HiveField(4) String? lastName,
            @HiveField(5) DateTime? dateJoined,
            @HiveField(6) bool isStaff,
            @HiveField(7) bool isActive,
            @HiveField(8) bool isSuperuser,
            @HiveField(9) List<int> groups,
            @HiveField(10) List<UserPermissions> userPermissions,
            @HiveField(11) List<InheritedPermissions> inheritedPermissions)?
        v3,
    TResult Function(@HiveField(0) @JsonKey(name: "user_id") int id,
            @HiveField(1) String username, @HiveField(2) String? displayName)?
        v2,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserModelV3 value) v3,
    required TResult Function(UserModelV2 value) v2,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserModelV3 value)? v3,
    TResult? Function(UserModelV2 value)? v2,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserModelV3 value)? v3,
    TResult Function(UserModelV2 value)? v2,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({@HiveField(0) int id, @HiveField(1) String username});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelV3CopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelV3CopyWith(
          _$UserModelV3 value, $Res Function(_$UserModelV3) then) =
      __$$UserModelV3CopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int id,
      @HiveField(1) String username,
      @HiveField(2) String email,
      @HiveField(3) String? firstName,
      @HiveField(4) String? lastName,
      @HiveField(5) DateTime? dateJoined,
      @HiveField(6) bool isStaff,
      @HiveField(7) bool isActive,
      @HiveField(8) bool isSuperuser,
      @HiveField(9) List<int> groups,
      @HiveField(10) List<UserPermissions> userPermissions,
      @HiveField(11) List<InheritedPermissions> inheritedPermissions});
}

/// @nodoc
class __$$UserModelV3CopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelV3>
    implements _$$UserModelV3CopyWith<$Res> {
  __$$UserModelV3CopyWithImpl(
      _$UserModelV3 _value, $Res Function(_$UserModelV3) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? dateJoined = freezed,
    Object? isStaff = null,
    Object? isActive = null,
    Object? isSuperuser = null,
    Object? groups = null,
    Object? userPermissions = null,
    Object? inheritedPermissions = null,
  }) {
    return _then(_$UserModelV3(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      dateJoined: freezed == dateJoined
          ? _value.dateJoined
          : dateJoined // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isStaff: null == isStaff
          ? _value.isStaff
          : isStaff // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isSuperuser: null == isSuperuser
          ? _value.isSuperuser
          : isSuperuser // ignore: cast_nullable_to_non_nullable
              as bool,
      groups: null == groups
          ? _value._groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<int>,
      userPermissions: null == userPermissions
          ? _value._userPermissions
          : userPermissions // ignore: cast_nullable_to_non_nullable
              as List<UserPermissions>,
      inheritedPermissions: null == inheritedPermissions
          ? _value._inheritedPermissions
          : inheritedPermissions // ignore: cast_nullable_to_non_nullable
              as List<InheritedPermissions>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
@HiveType(typeId: PaperlessApiHiveTypeIds.userModelv3)
class _$UserModelV3 extends UserModelV3 {
  const _$UserModelV3(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.username,
      @HiveField(2) required this.email,
      @HiveField(3) this.firstName,
      @HiveField(4) this.lastName,
      @HiveField(5) this.dateJoined,
      @HiveField(6) this.isStaff = true,
      @HiveField(7) this.isActive = true,
      @HiveField(8) this.isSuperuser = true,
      @HiveField(9) final List<int> groups = const [],
      @HiveField(10) final List<UserPermissions> userPermissions =
          UserPermissions.values,
      @HiveField(11) final List<InheritedPermissions> inheritedPermissions =
          InheritedPermissions.values,
      final String? $type})
      : _groups = groups,
        _userPermissions = userPermissions,
        _inheritedPermissions = inheritedPermissions,
        $type = $type ?? 'v3',
        super._();

  factory _$UserModelV3.fromJson(Map<String, dynamic> json) =>
      _$$UserModelV3FromJson(json);

  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String username;
  @override
  @HiveField(2)
  final String email;
  @override
  @HiveField(3)
  final String? firstName;
  @override
  @HiveField(4)
  final String? lastName;
  @override
  @HiveField(5)
  final DateTime? dateJoined;
  @override
  @JsonKey()
  @HiveField(6)
  final bool isStaff;
  @override
  @JsonKey()
  @HiveField(7)
  final bool isActive;
  @override
  @JsonKey()
  @HiveField(8)
  final bool isSuperuser;
  final List<int> _groups;
  @override
  @JsonKey()
  @HiveField(9)
  List<int> get groups {
    if (_groups is EqualUnmodifiableListView) return _groups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groups);
  }

  final List<UserPermissions> _userPermissions;
  @override
  @JsonKey()
  @HiveField(10)
  List<UserPermissions> get userPermissions {
    if (_userPermissions is EqualUnmodifiableListView) return _userPermissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userPermissions);
  }

  final List<InheritedPermissions> _inheritedPermissions;
  @override
  @JsonKey()
  @HiveField(11)
  List<InheritedPermissions> get inheritedPermissions {
    if (_inheritedPermissions is EqualUnmodifiableListView)
      return _inheritedPermissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inheritedPermissions);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'UserModel.v3(id: $id, username: $username, email: $email, firstName: $firstName, lastName: $lastName, dateJoined: $dateJoined, isStaff: $isStaff, isActive: $isActive, isSuperuser: $isSuperuser, groups: $groups, userPermissions: $userPermissions, inheritedPermissions: $inheritedPermissions)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelV3 &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.dateJoined, dateJoined) ||
                other.dateJoined == dateJoined) &&
            (identical(other.isStaff, isStaff) || other.isStaff == isStaff) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isSuperuser, isSuperuser) ||
                other.isSuperuser == isSuperuser) &&
            const DeepCollectionEquality().equals(other._groups, _groups) &&
            const DeepCollectionEquality()
                .equals(other._userPermissions, _userPermissions) &&
            const DeepCollectionEquality()
                .equals(other._inheritedPermissions, _inheritedPermissions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      username,
      email,
      firstName,
      lastName,
      dateJoined,
      isStaff,
      isActive,
      isSuperuser,
      const DeepCollectionEquality().hash(_groups),
      const DeepCollectionEquality().hash(_userPermissions),
      const DeepCollectionEquality().hash(_inheritedPermissions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelV3CopyWith<_$UserModelV3> get copyWith =>
      __$$UserModelV3CopyWithImpl<_$UserModelV3>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @HiveField(0) int id,
            @HiveField(1) String username,
            @HiveField(2) String email,
            @HiveField(3) String? firstName,
            @HiveField(4) String? lastName,
            @HiveField(5) DateTime? dateJoined,
            @HiveField(6) bool isStaff,
            @HiveField(7) bool isActive,
            @HiveField(8) bool isSuperuser,
            @HiveField(9) List<int> groups,
            @HiveField(10) List<UserPermissions> userPermissions,
            @HiveField(11) List<InheritedPermissions> inheritedPermissions)
        v3,
    required TResult Function(@HiveField(0) @JsonKey(name: "user_id") int id,
            @HiveField(1) String username, @HiveField(2) String? displayName)
        v2,
  }) {
    return v3(id, username, email, firstName, lastName, dateJoined, isStaff,
        isActive, isSuperuser, groups, userPermissions, inheritedPermissions);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @HiveField(0) int id,
            @HiveField(1) String username,
            @HiveField(2) String email,
            @HiveField(3) String? firstName,
            @HiveField(4) String? lastName,
            @HiveField(5) DateTime? dateJoined,
            @HiveField(6) bool isStaff,
            @HiveField(7) bool isActive,
            @HiveField(8) bool isSuperuser,
            @HiveField(9) List<int> groups,
            @HiveField(10) List<UserPermissions> userPermissions,
            @HiveField(11) List<InheritedPermissions> inheritedPermissions)?
        v3,
    TResult? Function(@HiveField(0) @JsonKey(name: "user_id") int id,
            @HiveField(1) String username, @HiveField(2) String? displayName)?
        v2,
  }) {
    return v3?.call(
        id,
        username,
        email,
        firstName,
        lastName,
        dateJoined,
        isStaff,
        isActive,
        isSuperuser,
        groups,
        userPermissions,
        inheritedPermissions);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @HiveField(0) int id,
            @HiveField(1) String username,
            @HiveField(2) String email,
            @HiveField(3) String? firstName,
            @HiveField(4) String? lastName,
            @HiveField(5) DateTime? dateJoined,
            @HiveField(6) bool isStaff,
            @HiveField(7) bool isActive,
            @HiveField(8) bool isSuperuser,
            @HiveField(9) List<int> groups,
            @HiveField(10) List<UserPermissions> userPermissions,
            @HiveField(11) List<InheritedPermissions> inheritedPermissions)?
        v3,
    TResult Function(@HiveField(0) @JsonKey(name: "user_id") int id,
            @HiveField(1) String username, @HiveField(2) String? displayName)?
        v2,
    required TResult orElse(),
  }) {
    if (v3 != null) {
      return v3(id, username, email, firstName, lastName, dateJoined, isStaff,
          isActive, isSuperuser, groups, userPermissions, inheritedPermissions);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserModelV3 value) v3,
    required TResult Function(UserModelV2 value) v2,
  }) {
    return v3(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserModelV3 value)? v3,
    TResult? Function(UserModelV2 value)? v2,
  }) {
    return v3?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserModelV3 value)? v3,
    TResult Function(UserModelV2 value)? v2,
    required TResult orElse(),
  }) {
    if (v3 != null) {
      return v3(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelV3ToJson(
      this,
    );
  }
}

abstract class UserModelV3 extends UserModel {
  const factory UserModelV3(
          {@HiveField(0)
              required final int id,
          @HiveField(1)
              required final String username,
          @HiveField(2)
              required final String email,
          @HiveField(3)
              final String? firstName,
          @HiveField(4)
              final String? lastName,
          @HiveField(5)
              final DateTime? dateJoined,
          @HiveField(6)
              final bool isStaff,
          @HiveField(7)
              final bool isActive,
          @HiveField(8)
              final bool isSuperuser,
          @HiveField(9)
              final List<int> groups,
          @HiveField(10)
              final List<UserPermissions> userPermissions,
          @HiveField(11)
              final List<InheritedPermissions> inheritedPermissions}) =
      _$UserModelV3;
  const UserModelV3._() : super._();

  factory UserModelV3.fromJson(Map<String, dynamic> json) =
      _$UserModelV3.fromJson;

  @override
  @HiveField(0)
  int get id;
  @override
  @HiveField(1)
  String get username;
  @HiveField(2)
  String get email;
  @HiveField(3)
  String? get firstName;
  @HiveField(4)
  String? get lastName;
  @HiveField(5)
  DateTime? get dateJoined;
  @HiveField(6)
  bool get isStaff;
  @HiveField(7)
  bool get isActive;
  @HiveField(8)
  bool get isSuperuser;
  @HiveField(9)
  List<int> get groups;
  @HiveField(10)
  List<UserPermissions> get userPermissions;
  @HiveField(11)
  List<InheritedPermissions> get inheritedPermissions;
  @override
  @JsonKey(ignore: true)
  _$$UserModelV3CopyWith<_$UserModelV3> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UserModelV2CopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelV2CopyWith(
          _$UserModelV2 value, $Res Function(_$UserModelV2) then) =
      __$$UserModelV2CopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) @JsonKey(name: "user_id") int id,
      @HiveField(1) String username,
      @HiveField(2) String? displayName});
}

/// @nodoc
class __$$UserModelV2CopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelV2>
    implements _$$UserModelV2CopyWith<$Res> {
  __$$UserModelV2CopyWithImpl(
      _$UserModelV2 _value, $Res Function(_$UserModelV2) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = freezed,
  }) {
    return _then(_$UserModelV2(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
@HiveType(typeId: PaperlessApiHiveTypeIds.userModelv2)
class _$UserModelV2 extends UserModelV2 {
  const _$UserModelV2(
      {@HiveField(0) @JsonKey(name: "user_id") required this.id,
      @HiveField(1) required this.username,
      @HiveField(2) this.displayName,
      final String? $type})
      : $type = $type ?? 'v2',
        super._();

  factory _$UserModelV2.fromJson(Map<String, dynamic> json) =>
      _$$UserModelV2FromJson(json);

  @override
  @HiveField(0)
  @JsonKey(name: "user_id")
  final int id;
  @override
  @HiveField(1)
  final String username;
  @override
  @HiveField(2)
  final String? displayName;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'UserModel.v2(id: $id, username: $username, displayName: $displayName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelV2 &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, username, displayName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelV2CopyWith<_$UserModelV2> get copyWith =>
      __$$UserModelV2CopyWithImpl<_$UserModelV2>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @HiveField(0) int id,
            @HiveField(1) String username,
            @HiveField(2) String email,
            @HiveField(3) String? firstName,
            @HiveField(4) String? lastName,
            @HiveField(5) DateTime? dateJoined,
            @HiveField(6) bool isStaff,
            @HiveField(7) bool isActive,
            @HiveField(8) bool isSuperuser,
            @HiveField(9) List<int> groups,
            @HiveField(10) List<UserPermissions> userPermissions,
            @HiveField(11) List<InheritedPermissions> inheritedPermissions)
        v3,
    required TResult Function(@HiveField(0) @JsonKey(name: "user_id") int id,
            @HiveField(1) String username, @HiveField(2) String? displayName)
        v2,
  }) {
    return v2(id, username, displayName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @HiveField(0) int id,
            @HiveField(1) String username,
            @HiveField(2) String email,
            @HiveField(3) String? firstName,
            @HiveField(4) String? lastName,
            @HiveField(5) DateTime? dateJoined,
            @HiveField(6) bool isStaff,
            @HiveField(7) bool isActive,
            @HiveField(8) bool isSuperuser,
            @HiveField(9) List<int> groups,
            @HiveField(10) List<UserPermissions> userPermissions,
            @HiveField(11) List<InheritedPermissions> inheritedPermissions)?
        v3,
    TResult? Function(@HiveField(0) @JsonKey(name: "user_id") int id,
            @HiveField(1) String username, @HiveField(2) String? displayName)?
        v2,
  }) {
    return v2?.call(id, username, displayName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @HiveField(0) int id,
            @HiveField(1) String username,
            @HiveField(2) String email,
            @HiveField(3) String? firstName,
            @HiveField(4) String? lastName,
            @HiveField(5) DateTime? dateJoined,
            @HiveField(6) bool isStaff,
            @HiveField(7) bool isActive,
            @HiveField(8) bool isSuperuser,
            @HiveField(9) List<int> groups,
            @HiveField(10) List<UserPermissions> userPermissions,
            @HiveField(11) List<InheritedPermissions> inheritedPermissions)?
        v3,
    TResult Function(@HiveField(0) @JsonKey(name: "user_id") int id,
            @HiveField(1) String username, @HiveField(2) String? displayName)?
        v2,
    required TResult orElse(),
  }) {
    if (v2 != null) {
      return v2(id, username, displayName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserModelV3 value) v3,
    required TResult Function(UserModelV2 value) v2,
  }) {
    return v2(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserModelV3 value)? v3,
    TResult? Function(UserModelV2 value)? v2,
  }) {
    return v2?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserModelV3 value)? v3,
    TResult Function(UserModelV2 value)? v2,
    required TResult orElse(),
  }) {
    if (v2 != null) {
      return v2(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelV2ToJson(
      this,
    );
  }
}

abstract class UserModelV2 extends UserModel {
  const factory UserModelV2(
      {@HiveField(0) @JsonKey(name: "user_id") required final int id,
      @HiveField(1) required final String username,
      @HiveField(2) final String? displayName}) = _$UserModelV2;
  const UserModelV2._() : super._();

  factory UserModelV2.fromJson(Map<String, dynamic> json) =
      _$UserModelV2.fromJson;

  @override
  @HiveField(0)
  @JsonKey(name: "user_id")
  int get id;
  @override
  @HiveField(1)
  String get username;
  @HiveField(2)
  String? get displayName;
  @override
  @JsonKey(ignore: true)
  _$$UserModelV2CopyWith<_$UserModelV2> get copyWith =>
      throw _privateConstructorUsedError;
}
