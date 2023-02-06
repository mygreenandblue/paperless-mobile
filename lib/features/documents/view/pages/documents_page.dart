import 'dart:developer';

import 'package:badges/badges.dart' as b;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/app_drawer/view/app_drawer.dart';
import 'package:paperless_mobile/features/document_search/view/document_search_page.dart';
import 'package:paperless_mobile/features/documents/bloc/documents_cubit.dart';
import 'package:paperless_mobile/features/documents/bloc/documents_state.dart';
import 'package:paperless_mobile/features/documents/view/widgets/adaptive_documents_view.dart';
import 'package:paperless_mobile/features/documents/view/widgets/documents_empty_state.dart';
import 'package:paperless_mobile/features/documents/view/widgets/search/document_filter_panel.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/bulk_delete_confirmation_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/sort_documents_button.dart';
import 'package:paperless_mobile/features/labels/bloc/providers/labels_bloc_provider.dart';
import 'package:paperless_mobile/features/saved_view/cubit/saved_view_cubit.dart';
import 'package:paperless_mobile/features/saved_view/view/add_saved_view_page.dart';
import 'package:paperless_mobile/features/saved_view/view/saved_view_list.dart';
import 'package:paperless_mobile/features/search_app_bar/view/search_app_bar.dart';
import 'package:paperless_mobile/features/settings/bloc/application_settings_cubit.dart';
import 'package:paperless_mobile/features/settings/bloc/application_settings_state.dart';
import 'package:paperless_mobile/features/settings/model/view_type.dart';
import 'package:paperless_mobile/features/tasks/cubit/task_status_cubit.dart';
import 'package:paperless_mobile/generated/l10n.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routes/document_details_route.dart';

class DocumentFilterIntent {
  final DocumentFilter? filter;
  final bool shouldReset;

  DocumentFilterIntent({
    this.filter,
    this.shouldReset = false,
  });
}

//TODO: Refactor this
class DocumentsPage extends StatefulWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    try {
      context.read<DocumentsCubit>().reload();
      context.read<SavedViewCubit>().reload();
    } on PaperlessServerException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
    _tabController.addListener(_listenForTabChanges);
  }

  void _listenForTabChanges() {
    setState(() {
      _currentTab = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskStatusCubit, TaskStatusState>(
      listenWhen: (previous, current) =>
          !previous.isSuccess && current.isSuccess,
      listener: (context, state) {
        showSnackBar(
          context,
          S.of(context).documentsPageNewDocumentAvailableText,
          action: SnackBarActionConfig(
            label: S
                .of(context)
                .documentUploadProcessingSuccessfulReloadActionText,
            onPressed: () {
              context.read<TaskStatusCubit>().acknowledgeCurrentTask();
              context.read<DocumentsCubit>().reload();
            },
          ),
          duration: const Duration(seconds: 10),
        );
      },
      child: BlocConsumer<ConnectivityCubit, ConnectivityState>(
        listenWhen: (previous, current) =>
            previous != ConnectivityState.connected &&
            current == ConnectivityState.connected,
        listener: (context, state) {
          try {
            context.read<DocumentsCubit>().reload();
          } on PaperlessServerException catch (error, stackTrace) {
            showErrorMessage(context, error, stackTrace);
          }
        },
        builder: (context, connectivityState) {
          return Scaffold(
            drawer: const AppDrawer(),
            floatingActionButton: BlocBuilder<DocumentsCubit, DocumentsState>(
              builder: (context, state) {
                final appliedFiltersCount = state.filter.appliedFiltersCount;
                return b.Badge(
                  position: b.BadgePosition.topEnd(top: -12, end: -6),
                  showBadge: appliedFiltersCount > 0,
                  badgeContent: Text(
                    '$appliedFiltersCount',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  animationType: b.BadgeAnimationType.fade,
                  badgeColor: Colors.red,
                  child: _currentTab == 0
                      ? FloatingActionButton(
                          child: const Icon(Icons.filter_alt_outlined),
                          onPressed: _openDocumentFilter,
                        )
                      : FloatingActionButton(
                          child: const Icon(Icons.add),
                          onPressed: () => _onCreateSavedView(state.filter),
                        ),
                );
              },
            ),
            resizeToAvoidBottomInset: true,
            body: WillPopScope(
              onWillPop: () async {
                if (context.read<DocumentsCubit>().state.selection.isNotEmpty) {
                  context.read<DocumentsCubit>().resetSelection();
                }
                return false;
              },
              child: NestedScrollView(
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
                    sliver: BlocBuilder<DocumentsCubit, DocumentsState>(
                      builder: (context, state) {
                        if (state.selection.isNotEmpty) {
                          return SliverAppBar(
                            floating: false,
                            pinned: true,
                            leading: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => context
                                  .read<DocumentsCubit>()
                                  .resetSelection(),
                            ),
                            title: Text(
                              "${state.selection.length} ${S.of(context).documentsSelectedText}",
                            ),
                            actions: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _onDelete(state),
                              ),
                            ],
                          );
                        }
                        return SearchAppBar(
                          hintText: S.of(context).documentSearchSearchDocuments,
                          onOpenSearch: showDocumentSearchPage,
                          bottom: TabBar(
                            controller: _tabController,
                            tabs: [
                              Tab(text: S.of(context).documentsPageTitle),
                              Tab(text: S.of(context).savedViewsLabel),
                            ],
                          ),
                        );
                      },
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
                        (metrics.pixels / metrics.maxScrollExtent).round();
                    if (metrics.axis == Axis.horizontal &&
                        _currentTab != desiredTab) {
                      setState(() => _currentTab = desiredTab);
                    }
                    return false;
                  },
                  child: NotificationListener<ScrollMetricsNotification>(
                    onNotification: (notification) {
                      // Listen for scroll notifications to load new data.
                      // Scroll controller does not work here due to nestedscrollview limitations.
                      final currState = context.read<DocumentsCubit>().state;
                      final max = notification.metrics.maxScrollExtent;
                      if (max == 0 ||
                          _currentTab != 0 ||
                          currState.isLoading ||
                          currState.isLastPageLoaded) {
                        return true;
                      }
                      final offset = notification.metrics.pixels;
                      if (offset >= max * 0.7) {
                        context
                            .read<DocumentsCubit>()
                            .loadMore()
                            .onError<PaperlessServerException>(
                              (error, stackTrace) => showErrorMessage(
                                context,
                                error,
                                stackTrace,
                              ),
                            );
                      }
                      return false;
                    },
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Builder(
                          builder: (context) {
                            return RefreshIndicator(
                              edgeOffset: kToolbarHeight + kTextTabBarHeight,
                              onRefresh: _onReloadDocuments,
                              notificationPredicate: (_) =>
                                  connectivityState.isConnected,
                              child: CustomScrollView(
                                key: const PageStorageKey<String>("documents"),
                                slivers: <Widget>[
                                  SliverOverlapInjector(
                                    handle: NestedScrollView
                                        .sliverOverlapAbsorberHandleFor(
                                            context),
                                  ),
                                  _buildViewActions(),
                                  BlocBuilder<DocumentsCubit, DocumentsState>(
                                    // Not required anymore since saved views are now handled separately
                                    // buildWhen: (previous, current) =>
                                    //     !const ListEquality().equals(
                                    //       previous.documents,
                                    //       current.documents,
                                    //     ) ||
                                    //     previous.selectedIds !=
                                    //         current.selectedIds,
                                    builder: (context, state) {
                                      if (state.hasLoaded &&
                                          state.documents.isEmpty) {
                                        return SliverToBoxAdapter(
                                          child: DocumentsEmptyState(
                                            state: state,
                                            onReset: () {
                                              context
                                                  .read<DocumentsCubit>()
                                                  .resetFilter();
                                            },
                                          ),
                                        );
                                      }
                                      return BlocBuilder<
                                          ApplicationSettingsCubit,
                                          ApplicationSettingsState>(
                                        builder: (context, settings) {
                                          return SliverAdaptiveDocumentsView(
                                            viewType:
                                                settings.preferredViewType,
                                            onTap: _openDetails,
                                            onSelected: context
                                                .read<DocumentsCubit>()
                                                .toggleDocumentSelection,
                                            hasInternetConnection:
                                                connectivityState.isConnected,
                                            onTagSelected: _addTagToFilter,
                                            onCorrespondentSelected:
                                                _addCorrespondentToFilter,
                                            onDocumentTypeSelected:
                                                _addDocumentTypeToFilter,
                                            onStoragePathSelected:
                                                _addStoragePathToFilter,
                                            documents: state.documents,
                                            hasLoaded: state.hasLoaded,
                                            isLabelClickable: true,
                                            isLoading: state.isLoading,
                                            selectedDocumentIds:
                                                state.selectedIds,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Builder(
                          builder: (context) {
                            return RefreshIndicator(
                              edgeOffset: kToolbarHeight + kTextTabBarHeight,
                              onRefresh: _onReloadSavedViews,
                              notificationPredicate: (_) =>
                                  connectivityState.isConnected,
                              child: CustomScrollView(
                                key: const PageStorageKey<String>("savedViews"),
                                slivers: <Widget>[
                                  SliverOverlapInjector(
                                    handle: NestedScrollView
                                        .sliverOverlapAbsorberHandleFor(
                                            context),
                                  ),
                                  const SavedViewList(),
                                ],
                              ),
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

  Widget _buildViewActions() {
    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SortDocumentsButton(),
          BlocBuilder<ApplicationSettingsCubit, ApplicationSettingsState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.preferredViewType == ViewType.list
                      ? Icons.grid_view_rounded
                      : Icons.list,
                ),
                onPressed: () =>
                    context.read<ApplicationSettingsCubit>().setViewType(
                          state.preferredViewType.toggle(),
                        ),
              );
            },
          )
        ],
      ).paddedSymmetrically(horizontal: 8, vertical: 4),
    );
  }

  void _onDelete(DocumentsState documentsState) async {
    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) =>
              BulkDeleteConfirmationDialog(state: documentsState),
        ) ??
        false;
    if (shouldDelete) {
      try {
        await context
            .read<DocumentsCubit>()
            .bulkDelete(documentsState.selection);
        showSnackBar(
          context,
          S.of(context).documentsPageBulkDeleteSuccessfulText,
        );
        context.read<DocumentsCubit>().resetSelection();
      } on PaperlessServerException catch (error, stackTrace) {
        showErrorMessage(context, error, stackTrace);
      }
    }
  }

  void _onCreateSavedView(DocumentFilter filter) async {
    final newView = await Navigator.of(context).push<SavedView?>(
      MaterialPageRoute(
        builder: (context) => LabelsBlocProvider(
          child: AddSavedViewPage(
            currentFilter: filter,
          ),
        ),
      ),
    );
    if (newView != null) {
      try {
        await context.read<SavedViewCubit>().add(newView);
      } on PaperlessServerException catch (error, stackTrace) {
        showErrorMessage(context, error, stackTrace);
      }
    }
  }

  void _openDocumentFilter() async {
    final draggableSheetController = DraggableScrollableController();
    final filterIntent = await showModalBottomSheet<DocumentFilterIntent>(
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<DocumentsCubit>(),
        child: DraggableScrollableSheet(
          controller: draggableSheetController,
          expand: false,
          snap: true,
          snapSizes: const [0.9, 1],
          initialChildSize: .9,
          maxChildSize: 1,
          builder: (context, controller) => LabelsBlocProvider(
            child: DocumentFilterPanel(
              initialFilter: context.read<DocumentsCubit>().state.filter,
              scrollController: controller,
              draggableSheetController: draggableSheetController,
            ),
          ),
        ),
      ),
    );
    if (filterIntent != null) {
      try {
        if (filterIntent.shouldReset) {
          await context.read<DocumentsCubit>().resetFilter();
        } else {
          await context
              .read<DocumentsCubit>()
              .updateFilter(filter: filterIntent.filter!);
        }
      } on PaperlessServerException catch (error, stackTrace) {
        showErrorMessage(context, error, stackTrace);
      }
    }
  }

  void _openDetails(DocumentModel document) {
    Navigator.pushNamed(
      context,
      DocumentDetailsRoute.routeName,
      arguments: DocumentDetailsRouteArguments(
        document: document,
      ),
    );
  }

  void _addTagToFilter(int tagId) {
    try {
      final tagsQuery =
          context.read<DocumentsCubit>().state.filter.tags is IdsTagsQuery
              ? context.read<DocumentsCubit>().state.filter.tags as IdsTagsQuery
              : const IdsTagsQuery();
      if (tagsQuery.includedIds.contains(tagId)) {
        context.read<DocumentsCubit>().updateCurrentFilter(
              (filter) => filter.copyWith(
                tags: tagsQuery.withIdsRemoved([tagId]),
              ),
            );
      } else {
        context.read<DocumentsCubit>().updateCurrentFilter(
              (filter) => filter.copyWith(
                tags: tagsQuery.withIdQueriesAdded([IncludeTagIdQuery(tagId)]),
              ),
            );
      }
    } on PaperlessServerException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  void _addCorrespondentToFilter(int? correspondentId) {
    final cubit = context.read<DocumentsCubit>();
    try {
      if (cubit.state.filter.correspondent.id == correspondentId) {
        cubit.updateCurrentFilter(
          (filter) =>
              filter.copyWith(correspondent: const IdQueryParameter.unset()),
        );
      } else {
        cubit.updateCurrentFilter(
          (filter) => filter.copyWith(
              correspondent: IdQueryParameter.fromId(correspondentId)),
        );
      }
    } on PaperlessServerException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  void _addDocumentTypeToFilter(int? documentTypeId) {
    final cubit = context.read<DocumentsCubit>();
    try {
      if (cubit.state.filter.documentType.id == documentTypeId) {
        cubit.updateCurrentFilter(
          (filter) =>
              filter.copyWith(documentType: const IdQueryParameter.unset()),
        );
      } else {
        cubit.updateCurrentFilter(
          (filter) => filter.copyWith(
              documentType: IdQueryParameter.fromId(documentTypeId)),
        );
      }
    } on PaperlessServerException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  void _addStoragePathToFilter(int? pathId) {
    final cubit = context.read<DocumentsCubit>();
    try {
      if (cubit.state.filter.correspondent.id == pathId) {
        cubit.updateCurrentFilter(
          (filter) =>
              filter.copyWith(storagePath: const IdQueryParameter.unset()),
        );
      } else {
        cubit.updateCurrentFilter(
          (filter) =>
              filter.copyWith(storagePath: IdQueryParameter.fromId(pathId)),
        );
      }
    } on PaperlessServerException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  Future<void> _onReloadDocuments() async {
    try {
      // We do not await here on purpose so we can show a linear progress indicator below the app bar.
      await context.read<DocumentsCubit>().reload();
    } on PaperlessServerException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  Future<void> _onReloadSavedViews() async {
    try {
      // We do not await here on purpose so we can show a linear progress indicator below the app bar.
      await context.read<SavedViewCubit>().reload();
    } on PaperlessServerException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }
}
