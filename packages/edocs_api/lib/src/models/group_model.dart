import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:edocs_api/edocs_api.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

@freezed
@HiveType(typeId: edocsApiHiveTypeIds.groupModel)
class GroupModel with _$GroupModel {
  const factory GroupModel({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) required List<String> permissions,
  }) = _GroupModel;

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);
}
