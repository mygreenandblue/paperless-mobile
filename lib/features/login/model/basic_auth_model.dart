import 'package:json_annotation/json_annotation.dart';

part 'basic_auth_model.g.dart';

@JsonSerializable()
class BasicAuthModel {
  final String? username;
  final String? password;

  BasicAuthModel({
    this.username,
    this.password,
  });

  BasicAuthModel copyWith({
    String? username,
    String? password,
  }) {
    return BasicAuthModel(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  factory BasicAuthModel.fromJson(Map<String, dynamic> json) =>
      _$BasicAuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$BasicAuthModelToJson(this);
}
