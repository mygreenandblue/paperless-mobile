import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/base_repository.dart';
import 'package:paperless_mobile/core/repository/state/impl/saved_view_repository_state.dart';
import 'package:paperless_mobile/core/repository/state/indexed_repository_state.dart';

abstract class SavedViewRepository extends BaseRepository<SavedView> {
  SavedViewRepository(super.initialState);
}
