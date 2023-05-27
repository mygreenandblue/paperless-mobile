part of 'user_repository.dart';

@freezed
class UserRepositoryState with _$UserRepositoryState {
  const factory UserRepositoryState({
    @Default({}) Map<int, UserModel> users,
  }) = _UserRepositoryState;

  factory UserRepositoryState.fromJson(Map<String, dynamic> json) =>
      _$UserRepositoryStateFromJson(json);
}
