import 'dart:convert';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:edocs_mobile/features/landing/view/widgets/folder_tree.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:edocs_mobile/features/saved_view_details/view/saved_view_non_Expandsion_preview.dart';
import 'package:edocs_mobile/routing/routes/labels_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:edocs_mobile/constants.dart';
import 'package:edocs_mobile/core/database/tables/local_user_account.dart';
import 'package:edocs_mobile/core/extensions/flutter_extensions.dart';
import 'package:edocs_mobile/features/app_drawer/view/app_drawer.dart';
import 'package:edocs_mobile/features/document_search/view/sliver_search_bar.dart';
import 'package:edocs_mobile/features/landing/view/widgets/expansion_card.dart';
import 'package:edocs_mobile/features/landing/view/widgets/mime_types_pie_chart.dart';
import 'package:edocs_mobile/features/saved_view/cubit/saved_view_cubit.dart';
import 'package:edocs_mobile/features/saved_view_details/view/saved_view_preview.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:edocs_mobile/routing/routes/changelog_route.dart';
import 'package:edocs_mobile/routing/routes/documents_route.dart';
import 'package:edocs_mobile/routing/routes/inbox_route.dart';
import 'package:edocs_mobile/routing/routes/saved_views_route.dart';
import 'package:edocs_mobile/routing/routes/shells/authenticated_route.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _searchBarHandle = SliverOverlapAbsorberHandle();
  TreeViewController? _controller;
  final Map<String, bool> loadedNodes = {};
  final Map<String, bool> _isLoading = {};

  Future<bool> get _shouldShowChangelog async {
    try {
      final sp = await SharedPreferences.getInstance();
      final currentBuild = packageInfo.buildNumber;
      final _existingVersions =
          sp.getStringList('changelogSeenForBuilds') ?? [];
      if (_existingVersions.contains(currentBuild)) {
        return false;
      } else {
        _existingVersions.add(currentBuild);
        await sp.setStringList('changelogSeenForBuilds', _existingVersions);
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (await _shouldShowChangelog) {
        ChangelogRoute().push(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<LocalUserAccount>().edocsUser;
    return SafeArea(
      child: Scaffold(
        drawer: const AppDrawer(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: _searchBarHandle,
              sliver: SliverSearchBar(
                titleText: S.of(context)!.documents,
              ),
            ),
          ],
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Text(
                  S.of(context)!.welcomeUser(
                        currentUser.fullName ?? currentUser.username,
                      ),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontSize: 28),
                ).padded(24),
              ),
              SliverToBoxAdapter(child: _buildStatisticsCard(context)),
              if (currentUser.canViewSavedViews) ...[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ).paddedOnly(right: 8),
                        Text(
                          S.of(context)!.personalMaterial,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                _buildFolderTree(context),
              ],
              if (currentUser.canViewSavedViews) ...[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Icon(
                          Icons.saved_search,
                          color: Theme.of(context).colorScheme.primary,
                        ).paddedOnly(right: 8),
                        Text(
                          S.of(context)!.views,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<SavedViewCubit, SavedViewState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loaded: (savedViews) {
                        final dashboardViews = savedViews.values
                            .where((element) => element.showOnDashboard)
                            .toList();
                        if (dashboardViews.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context)!.youDidNotSaveAnyViewsYet,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ).padded(),
                                TextButton.icon(
                                  onPressed: () {
                                    const CreateSavedViewRoute(
                                      showOnDashboard: true,
                                    ).push(context);
                                  },
                                  icon: const Icon(Icons.add),
                                  label: Text(S.of(context)!.newView),
                                )
                              ],
                            ).paddedOnly(left: 16),
                          );
                        }
                        return SliverList.builder(
                          itemBuilder: (context, index) {
                            return SavedViewPreview(
                              savedView: dashboardViews.elementAt(index),
                              expanded: index == 0,
                            );
                          },
                          itemCount: dashboardViews.length,
                        );
                      },
                      orElse: () => const SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(BuildContext context) {
    final currentUser = context.read<LocalUserAccount>().edocsUser;
    return ExpansionCard(
      initiallyExpanded: false,
      title: Text(
        S.of(context)!.statistics,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: FutureBuilder<EdocsServerStatisticsModel>(
        future: context.read<EdocsServerStatsApi>().getServerStatistics(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            ).paddedOnly(top: 8, bottom: 24);
          }
          final stats = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: ListTile(
                  shape: Theme.of(context).cardTheme.shape,
                  titleTextStyle: Theme.of(context).textTheme.labelLarge,
                  title: Text(S.of(context)!.documentsInInbox),
                  onTap: currentUser.canViewInbox
                      ? () => InboxRoute().go(context)
                      : null,
                  trailing: Text(
                    stats.documentsInInbox.toString(),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: ListTile(
                  shape: Theme.of(context).cardTheme.shape,
                  titleTextStyle: Theme.of(context).textTheme.labelLarge,
                  title: Text(S.of(context)!.totalDocuments),
                  onTap: currentUser.canViewDocuments
                      ? () {
                          DocumentsRoute().go(context);
                        }
                      : null,
                  trailing: Text(
                    stats.documentsTotal.toString(),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: ListTile(
                  shape: Theme.of(context).cardTheme.shape,
                  titleTextStyle: Theme.of(context).textTheme.labelLarge,
                  title: Text(S.of(context)!.totalCharacters),
                  trailing: Text(
                    (stats.totalChars ?? 0).toString(),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
              if (stats.fileTypeCounts.isNotEmpty)
                AspectRatio(
                  aspectRatio: 1.3,
                  child: SizedBox(
                    width: 300,
                    child: MimeTypesPieChart(statistics: stats),
                  ),
                ),
            ],
          ).padded(16);
        },
      ),
    );
  }

  _buildFolderTree(BuildContext context) {
    return BlocBuilder<DocumentsCubit, DocumentsState>(
      builder: (context, state) {
        context.read<LabelCubit>().buildTree();
        return BlocBuilder<LabelCubit, LabelState>(
          builder: (context, lbState) {
            return lbState.isLoading
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : lbState.folderTree!.length == 0
                    ? _buildEmptyTree(context)
                    : FolderTree(
                        labelState: lbState,
                        controller: _controller!,
                        isLoading: _isLoading);
          },
        );
      },
    );
  }

  TreeNode<dynamic> convertNodeToTreeNode(Node node) {
    return TreeNode<dynamic>(
      key: node.key,
      data: node.children,
    );
  }

  _buildTree(BuildContext context, LabelState lbState) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverTreeView.simple(
        tree: lbState.folderTree!,
        showRootNode: true,
        expansionIndicatorBuilder: (context, node) =>
            ChevronIndicator.rightDown(
          alignment: Alignment.centerRight,
          tree: node,
          padding: const EdgeInsets.all(16),
        ),
        indentation: const Indentation(style: IndentStyle.squareJoint),
        onTreeReady: (controller) {
          _controller = controller;
          // controller.expandAllChildren(lbState.folderTree!);
        },
        focusToNewNode: true,
        onItemTap: (value) {},
        builder: (context, node) {
          return node.level == 0
              ? GestureDetector(
                  onLongPressStart: (details) {
                    _showPopupMenu(context, details.globalPosition, node.data,
                        false, node.key, node);
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(S.of(context)!.personalMaterial),
                      subtitle: Text(S.of(context)!.allFileAndFolder),
                    ),
                  ),
                )
              : GestureDetector(
                  onLongPressStart: (details) {
                    if (node.data is Folder) {
                      _showPopupMenu(context, details.globalPosition, node.data,
                          true, node.key, node);
                    }
                  },
                  child: node.data.hasField(node.data.toJson(), 'mime_type')
                      ? const ListTile(
                          title: Text('aa'),
                          subtitle: Text('Level'),
                        )
                      : node.data is DocumentModel
                          ? SavedViewNonExpandsionPreview(
                              documentModel: node.data,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1.5,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .shadow
                                        .withOpacity(0.1),
                                  ),
                                ),
                              ),
                              child: ListTile(
                                key: UniqueKey(),
                                title: Text(node.data.getValue('name')),
                                subtitle: Text('Level ${node.level}'),
                                leading: _isLoading[
                                            node.data.getValue('checksum')] ==
                                        true
                                    ? const CircularProgressIndicator()
                                    : const Icon(Icons.folder_outlined),
                                onTap: () async {
                                  if (node.length != 0 &&
                                      _controller!
                                          .elementAt(node.path)
                                          .expansionNotifier
                                          .value &&
                                      _isLoading[
                                              node.data.getValue('checksum')] !=
                                          null) {
                                    _controller!.collapseNode(node);
                                    return;
                                  }
                                  setState(() {
                                    _isLoading[node.data.getValue('checksum')] =
                                        true;
                                  });
                                  await context
                                      .read<LabelCubit>()
                                      .loadChildNodes(
                                        node,
                                      );

                                  setState(() {
                                    _isLoading[node.data.getValue('checksum')] =
                                        false;
                                  });
                                  if (_controller!
                                      .elementAt(node.path)
                                      .expansionNotifier
                                      .value) {
                                    _controller!.toggleExpansion(node);
                                  }
                                },
                              ),
                            ),
                );
        },
      ),
    );
  }

  _buildEmptyTree(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context)!.youDidNotAnyFolderYet,
            style: Theme.of(context).textTheme.bodySmall,
          ).padded(),
          TextButton.icon(
            onPressed: () {
              CreateLabelRoute(
                LabelType.folders,
              ).push(context);
            },
            icon: const Icon(Icons.add),
            label: Text(S.of(context)!.newView),
          )
        ],
      ).paddedOnly(left: 16),
    );
  }

  Future<void> _showPopupMenu(BuildContext context, Offset offset,
      Folder? folder, bool enable, String key, TreeNode<dynamic> node) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem(
          enabled: enable,
          child: ListTile(
            leading: const Icon(Icons.edit),
            title: Text(S.of(context)!.edit),
            onTap: () async {
              Navigator.of(context).pop(); // Close the popup menu
              final updated = await EditLabelRoute(folder!).push(context);
              if (updated != null) {
                updated is bool && updated == true
                    ? context.read<LabelCubit>().removeNodeInTree(node)
                    : context
                        .read<LabelCubit>()
                        .replaceNodeInTree(key, updated, node);
              }
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: Text(S.of(context)!.addFolder),
            onTap: () async {
              Navigator.of(context).pop();
              final createdLabel =
                  await CreateLabelRoute(LabelType.folders, $extra: folder)
                      .push(context);
              if (createdLabel != null) {
                context
                    .read<LabelCubit>()
                    .addFolderToNode(key, createdLabel, node);
              }
            },
          ),
        ),
      ],
    );
  }
}
