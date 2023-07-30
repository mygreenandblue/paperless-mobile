import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/global_settings.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/factory/paperless_api_factory.dart';
import 'package:paperless_mobile/features/home/view/home_shell_widget.dart';
import 'package:paperless_mobile/routes/navigation_keys.dart';

//part 'provider_shell_route.g.dart';
//TODO: Wait for https://github.com/flutter/flutter/issues/127371 to be merged
// @TypedShellRoute<ProviderShellRoute>(
//   routes: [
//     TypedStatefulShellRoute(
//       branches: [
//         TypedStatefulShellBranch<LandingBranch>(
//           routes: [
//             TypedGoRoute<LandingRoute>(
//               path: "/landing",
//               // name: R.landing,
//             )
//           ],
//         ),
//         TypedStatefulShellBranch<DocumentsBranch>(
//           routes: [
//             TypedGoRoute<DocumentsRoute>(
//               path: "/documents",
//               routes: [
//                 TypedGoRoute<DocumentDetailsRoute>(
//                   path: "details",
//                   // name: R.documentDetails,
//                 ),
//                 TypedGoRoute<DocumentEditRoute>(
//                   path: "edit",
//                   // name: R.editDocument,
//                 ),
//               ],
//             )
//           ],
//         ),
//       ],
//     ),
//   ],
// )
class ProviderShellRoute extends ShellRouteData {
  final PaperlessApiFactory apiFactory;
  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  const ProviderShellRoute(this.apiFactory);

  Widget build(
    BuildContext context,
    GoRouterState state,
    Widget navigator,
  ) {
    final currentUserId = Hive.box<GlobalSettings>(HiveBoxes.globalSettings)
        .getValue()!
        .loggedInUserId!;
    final authenticatedUser =
        Hive.box<LocalUserAccount>(HiveBoxes.localUserAccount).get(
      currentUserId,
    )!;
    return HomeShellWidget(
      localUserId: authenticatedUser.id,
      paperlessApiVersion: authenticatedUser.apiVersion,
      paperlessProviderFactory: apiFactory,
      child: navigator,
    );
  }
}
