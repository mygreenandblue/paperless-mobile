// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:edocs_api/config/hive/hive_type_ids.dart';

part 'user_model.g.dart';

sealed class UserModel {
  int get id;

  String get username;

  const UserModel();

  String? get fullName;
}

@JsonSerializable(fieldRename: FieldRename.snake)
@HiveType(typeId: EdocsApiHiveTypeIds.userModelv2)
class UserModelV2 extends UserModel {
  @override
  @HiveField(0)
  @JsonKey(name: 'user_id')
  final int id;
  @override
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String? displayName;
  const UserModelV2({
    required this.id,
    required this.username,
    this.displayName,
  });
  Map<String, dynamic> toJson() => _$UserModelV2ToJson(this);
  factory UserModelV2.fromJson(Map<String, dynamic> json) =>
      _$UserModelV2FromJson(json);

  @override
  String? get fullName => displayName;
}

@JsonSerializable(fieldRename: FieldRename.snake)
@HiveType(typeId: EdocsApiHiveTypeIds.userModelv3)
class UserModelV3 extends UserModel {
  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final String? firstName;
  @HiveField(4)
  final String? lastName;
  @HiveField(5)
  final DateTime? dateJoined;
  @HiveField(6)
  final bool isStaff;
  @HiveField(7)
  final bool isActive;
  @HiveField(8)
  final bool isSuperuser;
  @HiveField(9)
  final List<int> groups;
  @HiveField(10)
  final List<String> userPermissions;
  @HiveField(11)
  final List<String> inheritedPermissions;

  @override
  String? get fullName {
    bool hasFirstName = firstName?.trim().isNotEmpty ?? false;
    bool hasLastName = lastName?.trim().isNotEmpty ?? false;
    if (hasFirstName && hasLastName) {
      return "${firstName!} ${lastName!}";
    } else if (hasFirstName) {
      return firstName!;
    } else if (hasLastName) {
      return lastName;
    }
    return null;
  }

  const UserModelV3({
    required this.id,
    required this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.dateJoined,
    required this.isStaff,
    required this.isActive,
    required this.isSuperuser,
    required this.groups,
    required this.userPermissions,
    required this.inheritedPermissions,
  });

  Map<String, dynamic> toJson() => _$UserModelV3ToJson(this);
  factory UserModelV3.fromJson(Map<String, dynamic> json) =>
      _$UserModelV3FromJson(json);
}
