import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/persistent_repository.dart';

part 'user_repository_state.dart';
part 'user_repository.freezed.dart';
part 'user_repository.g.dart';

/// Repository for new users (API v3, server version 1.14.2+)
class UserRepository extends PersistentRepository<UserRepositoryState> {
  final PaperlessUserApiV3 _userApiV3;

  UserRepository(this._userApiV3) : super(const UserRepositoryState());

  Future<void> initialize() async {
    await findAll();
  }

  Future<Iterable<UserModel>> findAll() async {
    final users = await _userApiV3.findAll();
    emit(state.copyWith(users: {for (var e in users) e.id: e}));
    return users;
  }

  Future<UserModel?> find(int id) async {
    final user = await _userApiV3.find(id);
    emit(state.copyWith(users: state.users..[id] = user));
    return user;
  }

  @override
  UserRepositoryState? fromJson(Map<String, dynamic> json) {
    return UserRepositoryState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(UserRepositoryState state) {
    return state.toJson();
  }
}
