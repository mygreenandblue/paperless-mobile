import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/delegate/customizable_sliver_persistent_header_delegate.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/widgets/material/colored_tab_bar.dart';
import 'package:paperless_mobile/features/app_drawer/view/app_drawer.dart';
import 'package:paperless_mobile/features/document_search/view/sliver_search_bar.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_correspondent_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_document_type_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_storage_path_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_tag_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/edit_correspondent_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/edit_document_type_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/edit_storage_path_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/edit_tag_page.dart';
import 'package:paperless_mobile/features/labels/cubit/label_cubit.dart';
import 'package:paperless_mobile/features/labels/cubit/label_cubit_mixin.dart';
import 'package:paperless_mobile/features/labels/view/widgets/label_tab_view.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class LabelsPage extends StatefulWidget {
  const LabelsPage({Key? key}) : super(key: key);

  @override
  State<LabelsPage> createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage>
    with SingleTickerProviderStateMixin {
  final SliverOverlapAbsorberHandle searchBarHandle =
      SliverOverlapAbsorberHandle();
  final SliverOverlapAbsorberHandle tabBarHandle =
      SliverOverlapAbsorberHandle();

  late final TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this)
      ..addListener(() => setState(() => _currentIndex = _tabController.index));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocBuilder<ConnectivityCubit, ConnectivityState>(
        builder: (context, connectedState) {
          return SafeArea(
            child: Scaffold(
              drawer: const AppDrawer(),
              floatingActionButton: FloatingActionButton(
                onPressed: [
                  _openAddCorrespondentPage,
                  _openAddDocumentTypePage,
                  _openAddTagPage,
                  _openAddStoragePathPage,
                ][_currentIndex],
                child: const Icon(Icons.add),
              ),
              body: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverOverlapAbsorber(
                    handle: searchBarHandle,
                    sliver: const SliverSearchBar(),
                  ),
                  SliverOverlapAbsorber(
                    handle: tabBarHandle,
                    sliver: SliverPersistentHeader(
                      pinned: true,
                      delegate: CustomizableSliverPersistentHeaderDelegate(
                          child: ColoredTabBar(
                            tabBar: TabBar(
                              controller: _tabController,
                              tabs: [
                                Tab(
                                  icon: Icon(
                                    Icons.person_outline,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                                Tab(
                                  icon: Icon(
                                    Icons.description_outlined,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                                Tab(
                                  icon: Icon(
                                    Icons.label_outline,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                                Tab(
                                  icon: Icon(
                                    Icons.folder_open,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          minExtent: kTextTabBarHeight,
                          maxExtent: kTextTabBarHeight),
                    ),
                  ),
                ],
                body: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    final metrics = notification.metrics;
                    if (metrics.maxScrollExtent == 0) {
                      return true;
                    }
                    final desiredTab =
                        ((metrics.pixels / metrics.maxScrollExtent) *
                                (_tabController.length - 1))
                            .round();

                    if (metrics.axis == Axis.horizontal &&
                        _currentIndex != desiredTab) {
                      setState(() => _currentIndex = desiredTab);
                    }
                    return true;
                  },
                  child: RefreshIndicator(
                    edgeOffset: kTextTabBarHeight,
                    notificationPredicate: (notification) =>
                        connectedState.isConnected,
                    onRefresh: () => [
                      context.read<LabelCubit>().reloadCorrespondents,
                      context.read<LabelCubit>().reloadDocumentTypes,
                      context.read<LabelCubit>().reloadTags,
                      context.read<LabelCubit>().reloadStoragePaths,
                    ][_currentIndex]
                        .call(),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Builder(
                          builder: (context) {
                            return CustomScrollView(
                              slivers: [
                                SliverOverlapInjector(handle: searchBarHandle),
                                SliverOverlapInjector(handle: tabBarHandle),
                                LabelTabView<Correspondent>(
                                  labels: context
                                      .watch<LabelCubit>()
                                      .state
                                      .correspondents,
                                  filterBuilder: (label) => DocumentFilter(
                                    correspondent:
                                        IdQueryParameter.fromId(label.id),
                                    pageSize: label.documentCount ?? 0,
                                  ),
                                  onEdit: _openEditCorrespondentPage,
                                  emptyStateActionButtonLabel:
                                      S.of(context)!.addNewCorrespondent,
                                  emptyStateDescription:
                                      S.of(context)!.noCorrespondentsSetUp,
                                  onAddNew: _openAddCorrespondentPage,
                                ),
                              ],
                            );
                          },
                        ),
                        Builder(
                          builder: (context) {
                            return CustomScrollView(
                              slivers: [
                                SliverOverlapInjector(handle: searchBarHandle),
                                SliverOverlapInjector(handle: tabBarHandle),
                                LabelTabView<DocumentType>(
                                  labels: context
                                      .watch<LabelCubit>()
                                      .state
                                      .documentTypes,
                                  filterBuilder: (label) => DocumentFilter(
                                    documentType:
                                        IdQueryParameter.fromId(label.id),
                                    pageSize: label.documentCount ?? 0,
                                  ),
                                  onEdit: _openEditDocumentTypePage,
                                  emptyStateActionButtonLabel:
                                      S.of(context)!.addNewDocumentType,
                                  emptyStateDescription:
                                      S.of(context)!.noDocumentTypesSetUp,
                                  onAddNew: _openAddDocumentTypePage,
                                ),
                              ],
                            );
                          },
                        ),
                        Builder(
                          builder: (context) {
                            return CustomScrollView(
                              slivers: [
                                SliverOverlapInjector(handle: searchBarHandle),
                                SliverOverlapInjector(handle: tabBarHandle),
                                LabelTabView<Tag>(
                                  labels:
                                      context.watch<LabelCubit>().state.tags,
                                  filterBuilder: (label) => DocumentFilter(
                                    tags: IdsTagsQuery.fromIds([label.id!]),
                                    pageSize: label.documentCount ?? 0,
                                  ),
                                  onEdit: _openEditTagPage,
                                  leadingBuilder: (t) => CircleAvatar(
                                    backgroundColor: t.color,
                                    child: t.isInboxTag ?? false
                                        ? Icon(
                                            Icons.inbox,
                                            color: t.textColor,
                                          )
                                        : null,
                                  ),
                                  emptyStateActionButtonLabel:
                                      S.of(context)!.addNewTag,
                                  emptyStateDescription:
                                      S.of(context)!.noTagsSetUp,
                                  onAddNew: _openAddTagPage,
                                ),
                              ],
                            );
                          },
                        ),
                        Builder(
                          builder: (context) {
                            return CustomScrollView(
                              slivers: [
                                SliverOverlapInjector(handle: searchBarHandle),
                                SliverOverlapInjector(handle: tabBarHandle),
                                LabelTabView<StoragePath>(
                                  labels: context
                                      .watch<LabelCubit>()
                                      .state
                                      .storagePaths,
                                  onEdit: _openEditStoragePathPage,
                                  filterBuilder: (label) => DocumentFilter(
                                    storagePath:
                                        IdQueryParameter.fromId(label.id),
                                    pageSize: label.documentCount ?? 0,
                                  ),
                                  contentBuilder: (path) => Text(path.path),
                                  emptyStateActionButtonLabel:
                                      S.of(context)!.addNewStoragePath,
                                  emptyStateDescription:
                                      S.of(context)!.noStoragePathsSetUp,
                                  onAddNew: _openAddStoragePathPage,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openEditCorrespondentPage(Correspondent correspondent) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: context.read<LabelRepository>(),
          child: EditCorrespondentPage(correspondent: correspondent),
        ),
      ),
    );
  }

  void _openEditDocumentTypePage(DocumentType docType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: context.read<LabelRepository>(),
          child: EditDocumentTypePage(documentType: docType),
        ),
      ),
    );
  }

  void _openEditTagPage(Tag tag) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: context.read<LabelRepository>(),
          child: EditTagPage(tag: tag),
        ),
      ),
    );
  }

  void _openEditStoragePathPage(StoragePath path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: context.read<LabelRepository>(),
          child: EditStoragePathPage(
            storagePath: path,
          ),
        ),
      ),
    );
  }

  void _openAddCorrespondentPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: context.read<LabelRepository>(),
          child: const AddCorrespondentPage(),
        ),
      ),
    );
  }

  void _openAddDocumentTypePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: context.read<LabelRepository>(),
          child: const AddDocumentTypePage(),
        ),
      ),
    );
  }

  void _openAddTagPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: context.read<LabelRepository>(),
          child: const AddTagPage(),
        ),
      ),
    );
  }

  void _openAddStoragePathPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: context.read<LabelRepository>(),
          child: const AddStoragePathPage(),
        ),
      ),
    );
  }
}
