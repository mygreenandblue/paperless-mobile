import 'package:hive_flutter/adapters.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
part 'user_app_state.g.dart';

@HiveType(typeId: HiveTypeIds.userAppState)
class UserAppState extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  DocumentFilter currentDocumentFilter;

  @HiveField(2)
  List<String> documentSearchHistory;

  UserAppState({
    required this.userId,
    this.currentDocumentFilter = const DocumentFilter(),
    this.documentSearchHistory = const [],
  });
}
