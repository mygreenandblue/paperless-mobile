import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/app_drawer/view/app_drawer.dart';
import 'package:paperless_mobile/features/inbox/cubit/inbox_cubit.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

const _landingPage = 0;
const _documentsIndex = 1;
const _scannerIndex = 2;
const _labelsIndex = 3;
const _inboxIndex = 4;

class ScaffoldWithNavigationBar extends StatefulWidget {
  final UserModel authenticatedUser;
  final StatefulNavigationShell navigationShell;
  const ScaffoldWithNavigationBar({
    super.key,
    required this.authenticatedUser,
    required this.navigationShell,
  });

  @override
  State<ScaffoldWithNavigationBar> createState() =>
      ScaffoldWithNavigationBarState();
}

class ScaffoldWithNavigationBarState extends State<ScaffoldWithNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final disabledColor = Theme.of(context).disabledColor;
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      drawer: const AppDrawer(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case _landingPage:
              widget.navigationShell.goBranch(index);
              break;
            case _documentsIndex:
              if (widget.authenticatedUser.canViewDocuments) {
                widget.navigationShell.goBranch(index);
              } else {
                showSnackBar(context,
                    "You do not have the required permissions to access this page.");
              }
              break;
            case _scannerIndex:
              if (widget.authenticatedUser.canCreateDocuments) {
                widget.navigationShell.goBranch(index);
              } else {
                showSnackBar(context,
                    "You do not have the required permissions to access this page.");
              }
              break;
            case _labelsIndex:
              if (widget.authenticatedUser.canViewAnyLabel) {
                widget.navigationShell.goBranch(index);
              } else {
                showSnackBar(context,
                    "You do not have the required permissions to access this page.");
              }
              break;
            case _inboxIndex:
              if (widget.authenticatedUser.canViewDocuments &&
                  widget.authenticatedUser.canViewTags) {
                widget.navigationShell.goBranch(index);
              } else {
                showSnackBar(context,
                    "You do not have the required permissions to access this page.");
              }
              break;
            default:
              break;
          }
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home,
              color: primaryColor,
            ),
            label: "Home", //TODO: INTL
          ),
          NavigationDestination(
            icon: Icon(
              Icons.description_outlined,
              color: !widget.authenticatedUser.canViewDocuments
                  ? disabledColor
                  : null,
            ),
            selectedIcon: Icon(
              Icons.description,
              color: primaryColor,
            ),
            label: S.of(context)!.documents,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.document_scanner_outlined,
              color: !widget.authenticatedUser.canCreateDocuments
                  ? disabledColor
                  : null,
            ),
            selectedIcon: Icon(
              Icons.document_scanner,
              color: primaryColor,
            ),
            label: S.of(context)!.scanner,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.sell_outlined,
              color: !widget.authenticatedUser.canViewAnyLabel
                  ? disabledColor
                  : null,
            ),
            selectedIcon: Icon(
              Icons.sell,
              color: primaryColor,
            ),
            label: S.of(context)!.labels,
          ),
          NavigationDestination(
            icon: Builder(builder: (context) {
              if (!(widget.authenticatedUser.canViewDocuments &&
                  widget.authenticatedUser.canViewTags)) {
                return Icon(
                  Icons.inbox_outlined,
                  color: disabledColor,
                );
              }
              return BlocBuilder<InboxCubit, InboxState>(
                builder: (context, state) {
                  return Badge.count(
                    isLabelVisible: state.itemsInInboxCount > 0,
                    count: state.itemsInInboxCount,
                    child: const Icon(Icons.inbox_outlined),
                  );
                },
              );
            }),
            selectedIcon: BlocBuilder<InboxCubit, InboxState>(
              builder: (context, state) {
                return Badge.count(
                  isLabelVisible: state.itemsInInboxCount > 0,
                  count: state.itemsInInboxCount,
                  child: Icon(
                    Icons.inbox,
                    color: primaryColor,
                  ),
                );
              },
            ),
            label: S.of(context)!.inbox,
          ),
        ],
      ),
      body: widget.navigationShell,
    );
  }
}
