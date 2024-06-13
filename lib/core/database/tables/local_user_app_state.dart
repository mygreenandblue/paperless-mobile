import 'package:hive_flutter/adapters.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/database/hive/hive_config.dart';
import 'package:edocs_mobile/core/database/tables/global_settings.dart';
import 'package:edocs_mobile/features/settings/model/view_type.dart';

part 'local_user_app_state.g.dart';

///
/// Object used for the persistence of app state, e.g. set filters,
/// search history and implicit settings.
///
@HiveType(typeId: HiveTypeIds.localUserAppState)
class LocalUserAppState extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  DocumentFilter currentDocumentFilter;

  @HiveField(2)
  List<String> documentSearchHistory;

  @HiveField(3)
  ViewType documentsPageViewType;

  @HiveField(4)
  ViewType savedViewsViewType;

  @HiveField(5)
  ViewType documentSearchViewType;

  LocalUserAppState({
    required this.userId,
    this.currentDocumentFilter = const DocumentFilter(),
    this.documentSearchHistory = const [],
    this.documentsPageViewType = ViewType.list,
    this.documentSearchViewType = ViewType.list,
    this.savedViewsViewType = ViewType.list,
  });

  static LocalUserAppState get current {
    final currentLocalUserId =
        Hive.box<GlobalSettings>(HiveBoxes.globalSettings)
            .getValue()!
            .loggedInUserId!;
    return Hive.box<LocalUserAppState>(HiveBoxes.localUserAppState)
        .get(currentLocalUserId)!;
  }
}
