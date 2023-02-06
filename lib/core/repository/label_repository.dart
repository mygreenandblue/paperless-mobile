import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/base_repository.dart';
import 'package:paperless_mobile/core/repository/state/indexed_repository_state.dart';

abstract class LabelRepository<T extends Label> extends BaseRepository<T> {
  LabelRepository(IndexedRepositoryState<T> initial) : super(initial);
}
