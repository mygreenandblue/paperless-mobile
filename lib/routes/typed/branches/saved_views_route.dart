import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/saved_view/view/add_saved_view_page.dart';

@TypedGoRoute(path: "/saved-views", routes: [])
class SavedViewsRoute extends GoRouteData {
  const SavedViewsRoute();
}

class CreateSavedViewRoute extends GoRouteData {
  final DocumentFilter? $extra;
  const CreateSavedViewRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AddSavedViewPage(
      initialFilter: $extra,
    );
  }
}

class EditSavedViewRoute extends GoRouteData {
  const EditSavedViewRoute();
}
