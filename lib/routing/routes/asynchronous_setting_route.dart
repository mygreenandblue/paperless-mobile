// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:edocs_mobile/features/settings/view/synchronous_setting_page.dart';
import 'package:edocs_mobile/routing/navigation_keys.dart';
import 'package:edocs_mobile/theme.dart';

class SynchronousSettingRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;
  final String directory;
  SynchronousSettingRoute({
    required this.directory,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: buildOverlayStyle(
        Theme.of(context),
        systemNavigationBarColor: Theme.of(context).colorScheme.background,
      ),
      child: SynchronousSettingPage(
        directory: Directory(directory),
      ),
    );
  }
}
