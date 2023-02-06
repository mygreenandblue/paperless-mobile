import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/repository/state/impl/correspondent_repository_state.dart';
import 'package:paperless_mobile/core/repository/state/impl/document_type_repository_state.dart';
import 'package:paperless_mobile/features/app_drawer/view/app_drawer.dart';
import 'package:paperless_mobile/features/document_search/view/document_search_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_correspondent_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_document_type_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_storage_path_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_tag_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/edit_correspondent_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/edit_document_type_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/edit_storage_path_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/edit_tag_page.dart';
import 'package:paperless_mobile/features/labels/bloc/label_cubit.dart';
import 'package:paperless_mobile/features/labels/view/widgets/label_tab_view.dart';
import 'package:paperless_mobile/features/search_app_bar/view/search_app_bar.dart';
import 'package:paperless_mobile/generated/l10n.dart';

class LabelsPage extends StatefulWidget {
  const LabelsPage({Key? key}) : super(key: key);

  @override
  State<LabelsPage> createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage>
    with SingleTickerProviderStateMixin {
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
          return Scaffold(
            drawer: const AppDrawer(),
            floatingActionButton: FloatingActionButton(
              onPressed: [
                _openAddCorrespondentPage,
                _openAddDocumentTypePage,
                _openAddTagPage,
                _openAddStoragePathPage,
              ][_currentIndex],
              child: Icon(Icons.add),
            ),
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverOverlapAbsorber(
                  // This widget takes the overlapping behavior of the SliverAppBar,
                  // and redirects it to the SliverOverlapInjector below. If it is
                  // missing, then it is possible for the nested "inner" scroll view
                  // below to end up under the SliverAppBar even when the inner
                  // scroll view thinks it has not been scrolled.
                  // This is not necessary if the "headerSliverBuilder" only builds
                  // widgets that do not overlap the next sliver.
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context,
                  ),
                  sliver: SearchAppBar(
                    hintText: S.of(context).documentSearchSearchDocuments,
                    onOpenSearch: showDocumentSearchPage,
                    bottom: TabBar(
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
                  edgeOffset: kToolbarHeight + kTextTabBarHeight,
                  notificationPredicate: (notification) =>
                      connectedState.isConnected,
                  onRefresh: () => [
                    context.read<LabelCubit<Correspondent>>(),
                    context.read<LabelCubit<DocumentType>>(),
                    context.read<LabelCubit<Tag>>(),
                    context.read<LabelCubit<StoragePath>>(),
                  ][_currentIndex]
                      .reload(),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Builder(
                        builder: (context) {
                          return CustomScrollView(
                            slivers: [
                              SliverOverlapInjector(
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context),
                              ),
                              LabelTabView<Correspondent>(
                                filterBuilder: (label) => DocumentFilter(
                                  correspondent:
                                      IdQueryParameter.fromId(label.id),
                                  pageSize: label.documentCount ?? 0,
                                ),
                                onEdit: _openEditCorrespondentPage,
                                emptyStateActionButtonLabel: S
                                    .of(context)
                                    .labelsPageCorrespondentEmptyStateAddNewLabel,
                                emptyStateDescription: S
                                    .of(context)
                                    .labelsPageCorrespondentEmptyStateDescriptionText,
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
                              SliverOverlapInjector(
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context),
                              ),
                              LabelTabView<DocumentType>(
                                filterBuilder: (label) => DocumentFilter(
                                  documentType:
                                      IdQueryParameter.fromId(label.id),
                                  pageSize: label.documentCount ?? 0,
                                ),
                                onEdit: _openEditDocumentTypePage,
                                emptyStateActionButtonLabel: S
                                    .of(context)
                                    .labelsPageDocumentTypeEmptyStateAddNewLabel,
                                emptyStateDescription: S
                                    .of(context)
                                    .labelsPageDocumentTypeEmptyStateDescriptionText,
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
                              SliverOverlapInjector(
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context),
                              ),
                              LabelTabView<Tag>(
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
                                emptyStateActionButtonLabel: S
                                    .of(context)
                                    .labelsPageTagsEmptyStateAddNewLabel,
                                emptyStateDescription: S
                                    .of(context)
                                    .labelsPageTagsEmptyStateDescriptionText,
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
                              SliverOverlapInjector(
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context),
                              ),
                              LabelTabView<StoragePath>(
                                onEdit: _openEditStoragePathPage,
                                filterBuilder: (label) => DocumentFilter(
                                  storagePath:
                                      IdQueryParameter.fromId(label.id),
                                  pageSize: label.documentCount ?? 0,
                                ),
                                contentBuilder: (path) => Text(path.path),
                                emptyStateActionButtonLabel: S
                                    .of(context)
                                    .labelsPageStoragePathEmptyStateAddNewLabel,
                                emptyStateDescription: S
                                    .of(context)
                                    .labelsPageStoragePathEmptyStateDescriptionText,
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
          );
        },
      ),
    );
  }

  void _openEditCorrespondentPage(Correspondent correspondent) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepositoryProvider(
          create: (context) => context.read<LabelRepository<Correspondent>>(),
          child: EditCorrespondentPage(correspondent: correspondent),
        ),
      ),
    );
  }

  void _openEditDocumentTypePage(DocumentType docType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepositoryProvider(
          create: (context) => context.read<LabelRepository<DocumentType>>(),
          child: EditDocumentTypePage(documentType: docType),
        ),
      ),
    );
  }

  void _openEditTagPage(Tag tag) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepositoryProvider(
          create: (context) => context.read<LabelRepository<Tag>>(),
          child: EditTagPage(tag: tag),
        ),
      ),
    );
  }

  void _openEditStoragePathPage(StoragePath path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepositoryProvider(
          create: (context) => context.read<LabelRepository<StoragePath>>(),
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
        builder: (_) => RepositoryProvider(
          create: (context) => context.read<LabelRepository<Correspondent>>(),
          child: const AddCorrespondentPage(),
        ),
      ),
    );
  }

  void _openAddDocumentTypePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepositoryProvider(
          create: (context) => context.read<LabelRepository<DocumentType>>(),
          child: const AddDocumentTypePage(),
        ),
      ),
    );
  }

  void _openAddTagPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepositoryProvider(
          create: (context) => context.read<LabelRepository<Tag>>(),
          child: const AddTagPage(),
        ),
      ),
    );
  }

  void _openAddStoragePathPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepositoryProvider(
          create: (context) => context.read<LabelRepository<StoragePath>>(),
          child: const AddStoragePathPage(),
        ),
      ),
    );
  }
}
