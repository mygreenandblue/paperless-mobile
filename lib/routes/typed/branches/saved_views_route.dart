import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/saved_view/view/add_saved_view_page.dart';
import 'package:paperless_mobile/features/saved_view/view/edit_saved_view_page.dart';
import 'package:paperless_mobile/routes/routes.dart';

part 'saved_views_route.g.dart';

@TypedGoRoute<SavedViewsRoute>(
  path: "/saved-views",
  routes: [
    TypedGoRoute<CreateSavedViewRoute>(
      path: "create",
      name: R.createSavedView,
    ),
    TypedGoRoute<EditSavedViewRoute>(
      path: "edit",
      name: R.editSavedView,
    ),
  ],
)
class SavedViewsRoute extends GoRouteData {
  const SavedViewsRoute();
}

class CreateSavedViewRoute extends GoRouteData {
  final DocumentFilter? $extra;
  const CreateSavedViewRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AddSavedViewPage(initialFilter: $extra);
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
