// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:paperless_api/config/hive/hive_type_ids.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  @HiveType(typeId: PaperlessApiHiveTypeIds.userModelv3)
  const factory UserModel.v3({
    @HiveField(0) required int id,
    @HiveField(1) required String username,
    @HiveField(2) String? email,
    @HiveField(3) String? firstName,
    @HiveField(4) String? lastName,
    @HiveField(5) DateTime? dateJoined,
    @HiveField(6) @Default(true) bool isStaff,
    @HiveField(7) @Default(true) bool isActive,
    @HiveField(8) @Default(true) bool isSuperuser,
    @HiveField(9) @Default([]) List<int> groups,
    @HiveField(10) @Default([]) List<String> userPermissions,
    @HiveField(11) @Default([]) List<String> inheritedPermissions,
  }) = UserModelV3;

  @JsonSerializable(fieldRename: FieldRename.snake)
  @HiveType(typeId: PaperlessApiHiveTypeIds.userModelv2)
  const factory UserModel.v2({
    @HiveField(0) @JsonKey(name: "user_id") required int id,
    @HiveField(1) required String username,
    @HiveField(2) String? displayName,
  }) = UserModelV2;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  String? get fullName => map(
        v2: (value) => value.displayName,
        v3: (value) {
          bool hasFirstName = value.firstName?.trim().isNotEmpty ?? false;
          bool hasLastName = value.lastName?.trim().isNotEmpty ?? false;
          if (hasFirstName && hasLastName) {
            return "${value.firstName!} ${value.lastName!}";
          } else if (hasFirstName) {
            return value.firstName!;
          } else if (hasLastName) {
            return value.lastName;
          } else {
            return null;
          }
        },
      );
}
