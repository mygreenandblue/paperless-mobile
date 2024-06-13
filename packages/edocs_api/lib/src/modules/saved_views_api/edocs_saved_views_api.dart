import 'package:edocs_api/src/models/saved_view_model.dart';

abstract class EdocsSavedViewsApi {
  Future<SavedView?> find(int id);
  Future<Iterable<SavedView>> findAll([Iterable<int>? ids]);

  Future<SavedView> save(SavedView view);
  Future<int> delete(SavedView view);

  /// Since API V3
  Future<SavedView> update(SavedView view);
}
