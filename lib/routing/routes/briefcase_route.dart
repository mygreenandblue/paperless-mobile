// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:paperless_mobile/features/physical_warehouse/view/briefcase_view.dart';
import 'package:paperless_mobile/features/physical_warehouse/view/pages/create_briefcase_page.dart';
import 'package:paperless_mobile/routing/navigation_keys.dart';
import 'package:paperless_mobile/theme.dart';

class BriefcaseRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: buildOverlayStyle(
        Theme.of(context),
        systemNavigationBarColor: Theme.of(context).colorScheme.background,
      ),
      child: const BriefcaseView(),
    );
  }
}

class CreateBriefcaseRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;
  final String? action;
  final String? name;
  final String? initialShelf;
  final String? initialWarehouse;
  CreateBriefcaseRoute({
    this.action,
    this.name,
    this.initialShelf,
    this.initialWarehouse,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CreateBriefcasePage(
      action: action!,
      name: name,
      initialShelf: initialShelf,
      initialWarehouse: initialWarehouse,
    );
  }
}
