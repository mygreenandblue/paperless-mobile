import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/global_settings.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
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
import 'package:paperless_mobile/features/home/view/model/api_version.dart';
import 'package:paperless_mobile/features/labels/cubit/label_cubit.dart';
import 'package:paperless_mobile/features/labels/view/widgets/label_tab_view.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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

  int _calculateTabCount(UserModel user) => [
        user.canViewCorrespondents,
        user.canViewDocumentTypes,
        user.canViewTags,
        user.canViewStoragePaths,
      ].fold(0, (value, element) => value + (element ? 1 : 0));

  @override
  void initState() {
    super.initState();
    final user = LocalUserAccount.current.paperlessUser;
    _tabController = TabController(
        length: _calculateTabCount(user), vsync: this)
      ..addListener(() => setState(() => _currentIndex = _tabController.index));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable:
            Hive.box<LocalUserAccount>(HiveBoxes.localUserAccount).listenable(),
        builder: (context, box, child) {
          final currentUserId =
              Hive.box<GlobalSettings>(HiveBoxes.globalSettings)
                  .getValue()!
                  .currentLoggedInUser;
          final user = box.get(currentUserId)!.paperlessUser;

          return BlocBuilder<ConnectivityCubit, ConnectivityState>(
            builder: (context, connectedState) {
              return SafeArea(
                child: Scaffold(
                  drawer: const AppDrawer(),
                  floatingActionButton: FloatingActionButton(
                    onPressed: [
                      if (user.canViewCorrespondents) _openAddCorrespondentPage,
                      if (user.canViewDocumentTypes) _openAddDocumentTypePage,
                      if (user.canViewTags) _openAddTagPage,
                      if (user.canViewStoragePaths) _openAddStoragePathPage,
                    ][_currentIndex],
                    child: const Icon(Icons.add),
                  ),
                  body: NestedScrollView(
                    floatHeaderSlivers: true,
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverOverlapAbsorber(
                        handle: searchBarHandle,
                        sliver: SliverSearchBar(
                          titleText: S.of(context)!.labels,
                        ),
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
                                  if (user.canViewCorrespondents)
                                    Tab(
                                      icon: Tooltip(
                                        message: S.of(context)!.correspondents,
                                        child: Icon(
                                          Icons.person_outline,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                      ),
                                    ),
                                  if (user.canViewDocumentTypes)
                                    Tab(
                                      icon: Tooltip(
                                        message: S.of(context)!.documentTypes,
                                        child: Icon(
                                          Icons.description_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                      ),
                                    ),
                                  if (user.canViewTags)
                                    Tab(
                                      icon: Tooltip(
                                        message: S.of(context)!.tags,
                                        child: Icon(
                                          Icons.label_outline,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                      ),
                                    ),
                                  if (user.canViewStoragePaths)
                                    Tab(
                                      icon: Tooltip(
                                        message: S.of(context)!.storagePaths,
                                        child: Icon(
                                          Icons.folder_open,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            minExtent: kTextTabBarHeight,
                            maxExtent: kTextTabBarHeight,
                          ),
                        ),
                      ),
                    ],
                    body: BlocBuilder<LabelCubit, LabelState>(
                      builder: (context, state) {
                        return NotificationListener<ScrollNotification>(
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
                            onRefresh: () async {
                              try {
                                await [
                                  context
                                      .read<LabelCubit>()
                                      .reloadCorrespondents,
                                  context
                                      .read<LabelCubit>()
                                      .reloadDocumentTypes,
                                  context.read<LabelCubit>().reloadTags,
                                  context.read<LabelCubit>().reloadStoragePaths,
                                ][_currentIndex]
                                    .call();
                              } catch (error, stackTrace) {
                                debugPrint(
                                  "[LabelsPage] RefreshIndicator.onRefresh "
                                  "${[
                                    "correspondents",
                                    "document types",
                                    "tags",
                                    "storage paths"
                                  ][_currentIndex]}: "
                                  "An error occurred (${error.toString()})",
                                );
                                debugPrintStack(stackTrace: stackTrace);
                              }
                            },
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                if (user.canViewCorrespondents)
                                  Builder(
                                    builder: (context) {
                                      return CustomScrollView(
                                        slivers: [
                                          SliverOverlapInjector(
                                              handle: searchBarHandle),
                                          SliverOverlapInjector(
                                              handle: tabBarHandle),
                                          LabelTabView<Correspondent>(
                                            labels: state.correspondents,
                                            filterBuilder: (label) =>
                                                DocumentFilter(
                                              correspondent:
                                                  IdQueryParameter.fromId(
                                                      label.id!),
                                            ),
                                            canEdit: user.canEditCorrespondents,
                                            canAddNew:
                                                user.canCreateCorrespondents,
                                            onEdit: _openEditCorrespondentPage,
                                            emptyStateActionButtonLabel: S
                                                .of(context)!
                                                .addNewCorrespondent,
                                            emptyStateDescription: S
                                                .of(context)!
                                                .noCorrespondentsSetUp,
                                            onAddNew: _openAddCorrespondentPage,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                if (user.canViewDocumentTypes)
                                  Builder(
                                    builder: (context) {
                                      return CustomScrollView(
                                        slivers: [
                                          SliverOverlapInjector(
                                              handle: searchBarHandle),
                                          SliverOverlapInjector(
                                              handle: tabBarHandle),
                                          LabelTabView<DocumentType>(
                                            labels: state.documentTypes,
                                            filterBuilder: (label) =>
                                                DocumentFilter(
                                              documentType:
                                                  IdQueryParameter.fromId(
                                                      label.id!),
                                            ),
                                            canEdit: user.canEditDocumentTypes,
                                            canAddNew:
                                                user.canCreateDocumentTypes,
                                            onEdit: _openEditDocumentTypePage,
                                            emptyStateActionButtonLabel: S
                                                .of(context)!
                                                .addNewDocumentType,
                                            emptyStateDescription: S
                                                .of(context)!
                                                .noDocumentTypesSetUp,
                                            onAddNew: _openAddDocumentTypePage,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                if (user.canViewTags)
                                  Builder(
                                    builder: (context) {
                                      return CustomScrollView(
                                        slivers: [
                                          SliverOverlapInjector(
                                              handle: searchBarHandle),
                                          SliverOverlapInjector(
                                              handle: tabBarHandle),
                                          LabelTabView<Tag>(
                                            labels: state.tags,
                                            filterBuilder: (label) =>
                                                DocumentFilter(
                                              tags: TagsQuery.ids(
                                                  include: [label.id!]),
                                            ),
                                            canEdit: user.canEditTags,
                                            canAddNew: user.canCreateTags,
                                            onEdit: _openEditTagPage,
                                            leadingBuilder: (t) => CircleAvatar(
                                              backgroundColor: t.color,
                                              child: t.isInboxTag
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
                                if (user.canViewStoragePaths)
                                  Builder(
                                    builder: (context) {
                                      return CustomScrollView(
                                        slivers: [
                                          SliverOverlapInjector(
                                              handle: searchBarHandle),
                                          SliverOverlapInjector(
                                              handle: tabBarHandle),
                                          LabelTabView<StoragePath>(
                                            labels: state.storagePaths,
                                            onEdit: _openEditStoragePathPage,
                                            filterBuilder: (label) =>
                                                DocumentFilter(
                                              storagePath:
                                                  IdQueryParameter.fromId(
                                                      label.id!),
                                            ),
                                            canEdit: user.canEditStoragePaths,
                                            canAddNew:
                                                user.canCreateStoragePaths,
                                            contentBuilder: (path) =>
                                                Text(path.path),
                                            emptyStateActionButtonLabel: S
                                                .of(context)!
                                                .addNewStoragePath,
                                            emptyStateDescription: S
                                                .of(context)!
                                                .noStoragePathsSetUp,
                                            onAddNew: _openAddStoragePathPage,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  void _openEditCorrespondentPage(Correspondent correspondent) {
    Navigator.push(
      context,
      _buildLabelPageRoute(EditCorrespondentPage(correspondent: correspondent)),
    );
  }

  void _openEditDocumentTypePage(DocumentType docType) {
    Navigator.push(
      context,
      _buildLabelPageRoute(EditDocumentTypePage(documentType: docType)),
    );
  }

  void _openEditTagPage(Tag tag) {
    Navigator.push(
      context,
      _buildLabelPageRoute(EditTagPage(tag: tag)),
    );
  }

  void _openEditStoragePathPage(StoragePath path) {
    Navigator.push(
      context,
      _buildLabelPageRoute(EditStoragePathPage(
        storagePath: path,
      )),
    );
  }

  void _openAddCorrespondentPage() {
    Navigator.push(
      context,
      _buildLabelPageRoute(const AddCorrespondentPage()),
    );
  }

  void _openAddDocumentTypePage() {
    Navigator.push(
      context,
      _buildLabelPageRoute(const AddDocumentTypePage()),
    );
  }

  void _openAddTagPage() {
    Navigator.push(
      context,
      _buildLabelPageRoute(const AddTagPage()),
    );
  }

  void _openAddStoragePathPage() {
    Navigator.push(
      context,
      _buildLabelPageRoute(const AddStoragePathPage()),
    );
  }

  MaterialPageRoute<dynamic> _buildLabelPageRoute(Widget page) {
    return MaterialPageRoute(
      builder: (_) => MultiProvider(
        providers: [
          Provider.value(value: context.read<LabelRepository>()),
          Provider.value(value: context.read<ApiVersion>())
        ],
        child: page,
      ),
    );
  }
}
