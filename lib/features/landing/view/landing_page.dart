import 'package:edocs_mobile/features/landing/view/widgets/folder_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
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

import 'package:edocs_mobile/routing/routes/saved_views_route.dart';
import 'package:edocs_mobile/routing/routes/shells/authenticated_route.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _searchBarHandle = SliverOverlapAbsorberHandle();

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
                    ? const EmtyFolderTree()
                    : FolderTree(
                        tree: lbState.folderTree!,
                      );
          },
        );
      },
    );
  }
}
