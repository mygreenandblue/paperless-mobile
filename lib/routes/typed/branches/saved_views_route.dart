import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/saved_view/view/add_saved_view_page.dart';
import 'package:paperless_mobile/features/saved_view/view/edit_saved_view_page.dart';

class SavedViewsRoute extends GoRouteData {
  const SavedViewsRoute();
}

class CreateSavedViewRoute extends GoRouteData {
  final DocumentFilter? $extra;
  final bool? showOnDashboard;
  final bool? showInSidebar;
  const CreateSavedViewRoute({
    this.$extra = const DocumentFilter(),
    this.showOnDashboard,
    this.showInSidebar,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AddSavedViewPage(
      initialFilter: $extra,
      showInSidebar: showInSidebar,
      showOnDashboard: showOnDashboard,
    );
  }
}

class EditSavedViewRoute extends GoRouteData {
  final SavedView $extra;
  const EditSavedViewRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EditSavedViewPage(savedView: $extra);
  }
}
