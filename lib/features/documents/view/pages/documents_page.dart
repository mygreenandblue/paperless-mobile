import 'package:badges/badges.dart' as b;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/features/app_drawer/view/app_drawer.dart';
import 'package:paperless_mobile/features/document_search/view/sliver_search_bar.dart';
import 'package:paperless_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:paperless_mobile/features/documents/view/widgets/adaptive_documents_view.dart';
import 'package:paperless_mobile/features/documents/view/widgets/documents_empty_state.dart';
import 'package:paperless_mobile/features/documents/view/widgets/saved_views/saved_view_changed_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/saved_views/saved_views_widget.dart';
import 'package:paperless_mobile/features/documents/view/widgets/search/document_filter_panel.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/confirm_delete_saved_view_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/document_selection_sliver_app_bar.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/view_type_selection_widget.dart';
import 'package:paperless_mobile/features/documents/view/widgets/sort_documents_button.dart';
import 'package:paperless_mobile/features/saved_view/cubit/saved_view_cubit.dart';
import 'package:paperless_mobile/features/saved_view/view/saved_view_list.dart';
import 'package:paperless_mobile/features/tasks/cubit/task_status_cubit.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routes/typed/branches/documents_route.dart';
import 'package:sliver_tools/sliver_tools.dart';

class DocumentFilterIntent {
  final DocumentFilter? filter;
  final bool shouldReset;

  DocumentFilterIntent({
    this.filter,
    this.shouldReset = false,
  });
}

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage>
    with SingleTickerProviderStateMixin {
  final SliverOverlapAbsorberHandle searchBarHandle =
      SliverOverlapAbsorberHandle();

  final SliverOverlapAbsorberHandle savedViewsHandle =
      SliverOverlapAbsorberHandle();
  late final TabController _tabController;

  int _currentTab = 0;
  final _savedViewsExpansionController = ExpansionTileController();
  @override
  void initState() {
    super.initState();
    final showSavedViews =
        context.read<LocalUserAccount>().paperlessUser.canViewSavedViews;
    _tabController = TabController(
      length: showSavedViews ? 2 : 1,
      vsync: this,
    );
    // Future.wait([
    //   context.read<DocumentsCubit>().reload(),
    //   context.read<SavedViewCubit>().reload(),
    // ]).onError<PaperlessApiException>(
    //   (error, stackTrace) {
    //     showErrorMessage(context, error, stackTrace);
    //     return [];
    //   },
    // );
    _tabController.addListener(_tabChangesListener);
  }

  void _tabChangesListener() {
    setState(() => _currentTab = _tabController.index);
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
          S.of(context)!.newDocumentAvailable,
          action: SnackBarActionConfig(
            label: S.of(context)!.reload,
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
          } on PaperlessApiException catch (error, stackTrace) {
            showErrorMessage(context, error, stackTrace);
          }
        },
        builder: (context, connectivityState) {
          return SafeArea(
            top: true,
            child: Scaffold(
              drawer: const AppDrawer(),
              floatingActionButton: BlocBuilder<DocumentsCubit, DocumentsState>(
                builder: (context, state) {
                  final appliedFiltersCount = state.filter.appliedFiltersCount;
                  final show = state.selection.isEmpty;
                  final canReset = state.filter.appliedFiltersCount > 0;
                  return AnimatedScale(
                    scale: show ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (canReset)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton.small(
                              heroTag: "fab_documents_page_reset_filter",
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              onPressed: () {
                                _onResetFilter();
                              },
                              child: Icon(
                                Icons.refresh,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                            ),
                          ),
                        b.Badge(
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
                          child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Builder(builder: (context) {
                                return FloatingActionButton(
                                  heroTag: "fab_documents_page_filter",
                                  child: const Icon(Icons.filter_alt_outlined),
                                  onPressed: _openDocumentFilter,
                                );
                              })),
                        ),
                      ],
                    ),
                  );
                },
              ),
              resizeToAvoidBottomInset: true,
              body: WillPopScope(
                onWillPop: () async {
                  if (context
                      .read<DocumentsCubit>()
                      .state
                      .selection
                      .isNotEmpty) {
                    context.read<DocumentsCubit>().resetSelection();
                    return false;
                  }
                  return true;
                },
                child: Stack(
                  children: [
                    NestedScrollView(
                      floatHeaderSlivers: true,
                      headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        SliverOverlapAbsorber(
                          handle: searchBarHandle,
                          sliver: BlocBuilder<DocumentsCubit, DocumentsState>(
                            builder: (context, state) {
                              if (state.selection.isEmpty) {
                                return SliverSearchBar(
                                  floating: true,
                                  titleText: S.of(context)!.documents,
                                );
                              } else {
                                return DocumentSelectionSliverAppBar(
                                  state: state,
                                );
                              }
                            },
                          ),
                        ),
                        SliverOverlapAbsorber(
                          handle: savedViewsHandle,
                          sliver: SliverPinnedHeader(
                            child: Material(
                              child: _buildViewActions(),
                              elevation: 4,
                            ),
                          ),
                        ),
                        // SliverOverlapAbsorber(
                        //   handle: tabBarHandle,
                        //   sliver: BlocBuilder<DocumentsCubit, DocumentsState>(
                        //     builder: (context, state) {
                        //       if (state.selection.isNotEmpty) {
                        //         return const SliverToBoxAdapter(
                        //           child: SizedBox.shrink(),
                        //         );
                        //       }
                        //       return SliverPersistentHeader(
                        //         pinned: true,
                        //         delegate:
                        //             CustomizableSliverPersistentHeaderDelegate(
                        //           minExtent: kTextTabBarHeight,
                        //           maxExtent: kTextTabBarHeight,
                        //           child: ColoredTabBar(
                        //             tabBar: TabBar(
                        //               controller: _tabController,
                        //               tabs: [
                        //                 Tab(text: S.of(context)!.documents),
                        //                 if (context
                        //                     .watch<LocalUserAccount>()
                        //                     .paperlessUser
                        //                     .canViewSavedViews)
                        // Tab(text: S.of(context)!.views),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                      body: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          final metrics = notification.metrics;
                          if (metrics.maxScrollExtent == 0) {
                            return true;
                          }
                          final desiredTab =
                              (metrics.pixels / metrics.maxScrollExtent)
                                  .round();
                          if (metrics.axis == Axis.horizontal &&
                              _currentTab != desiredTab) {
                            setState(() => _currentTab = desiredTab);
                          }
                          return false;
                        },
                        child: _buildDocumentsTab(
                          connectivityState,
                          context,
                        ),
                      ),
                    ),
                    _buildSavedViewChangedIndicator(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSavedViewChangedIndicator() {
    return BlocBuilder<DocumentsCubit, DocumentsState>(
      builder: (context, state) {
        final savedViewCubit = context.watch<SavedViewCubit>();
        final activeView = savedViewCubit.state.maybeMap(
          loaded: (savedViewState) {
            if (state.filter.selectedView != null) {
              return savedViewState.savedViews[state.filter.selectedView!];
            }
            return null;
          },
          orElse: () => null,
        );
        final viewHasChanged =
            activeView != null && activeView.toDocumentFilter() != state.filter;
        return AnimatedScale(
          scale: viewHasChanged ? 1 : 0,
          alignment: Alignment.bottomCenter,
          duration: const Duration(milliseconds: 300),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: Material(
                borderRadius: BorderRadius.circular(24),
                color: Theme.of(context)
                    .colorScheme
                    .surfaceVariant
                    .withOpacity(0.9),
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onTap: () async {
                    await _updateCurrentSavedView();
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      "Update selected view",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget _buildSavedViewsTab(
  //   ConnectivityState connectivityState,
  //   BuildContext context,
  // ) {
  //   return RefreshIndicator(
  //     edgeOffset: kTextTabBarHeight,
  //     onRefresh: _onReloadSavedViews,
  //     notificationPredicate: (_) => connectivityState.isConnected,
  //     child: CustomScrollView(
  //       key: const PageStorageKey<String>("savedViews"),
  //       slivers: [
  //         SliverOverlapInjector(
  //           handle: searchBarHandle,
  //         ),
  //         SliverOverlapInjector(
  //           handle: savedViewsHandle,
  //         ),
  //         const SavedViewList(),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDocumentsTab(
    ConnectivityState connectivityState,
    BuildContext context,
  ) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // Listen for scroll notifications to load new data.
        // Scroll controller does not work here due to nestedscrollview limitations.
        final offset = notification.metrics.pixels;
        if (offset > 128 && _savedViewsExpansionController.isExpanded) {
          _savedViewsExpansionController.collapse();
        }

        final currState = context.read<DocumentsCubit>().state;
        final max = notification.metrics.maxScrollExtent;
        if (max == 0 ||
            _currentTab != 0 ||
            currState.isLoading ||
            currState.isLastPageLoaded) {
          return false;
        }

        if (offset >= max * 0.7) {
          context
              .read<DocumentsCubit>()
              .loadMore()
              .onError<PaperlessApiException>(
                (error, stackTrace) => showErrorMessage(
                  context,
                  error,
                  stackTrace,
                ),
              );
          return true;
        }
        return false;
      },
      child: RefreshIndicator(
        edgeOffset: kTextTabBarHeight + 2,
        onRefresh: _onReloadDocuments,
        notificationPredicate: (_) => connectivityState.isConnected,
        child: CustomScrollView(
          key: const PageStorageKey<String>("documents"),
          slivers: <Widget>[
            SliverOverlapInjector(handle: searchBarHandle),
            SliverOverlapInjector(handle: savedViewsHandle),
            BlocBuilder<DocumentsCubit, DocumentsState>(
              buildWhen: (previous, current) =>
                  previous.filter != current.filter,
              builder: (context, state) {
                return SliverToBoxAdapter(
                  child: SavedViewsWidget(
                    controller: _savedViewsExpansionController,
                    onViewSelected: (view) {
                      final cubit = context.read<DocumentsCubit>();
                      if (state.filter.selectedView == view.id) {
                        _onResetFilter();
                      } else {
                        cubit.updateFilter(
                          filter: view.toDocumentFilter(),
                        );
                      }
                    },
                    onUpdateView: (view) async {
                      await context.read<SavedViewCubit>().update(view);
                      showSnackBar(context,
                          "Saved view successfully updated."); //TODO: INTL
                    },
                    onDeleteView: (view) async {
                      HapticFeedback.mediumImpact();
                      final shouldRemove = await showDialog(
                        context: context,
                        builder: (context) =>
                            ConfirmDeleteSavedViewDialog(view: view),
                      );
                      if (shouldRemove) {
                        final documentsCubit = context.read<DocumentsCubit>();
                        context.read<SavedViewCubit>().remove(view);
                        if (documentsCubit.state.filter.selectedView ==
                            view.id) {
                          documentsCubit.resetFilter();
                        }
                      }
                    },
                    filter: state.filter,
                  ),
                );
              },
            ),
            BlocBuilder<DocumentsCubit, DocumentsState>(
              builder: (context, state) {
                if (state.hasLoaded && state.documents.isEmpty) {
                  return SliverToBoxAdapter(
                    child: DocumentsEmptyState(
                      state: state,
                      onReset: _onResetFilter,
                    ),
                  );
                }
                final allowToggleFilter = state.selection.isEmpty;
                return SliverAdaptiveDocumentsView(
                  viewType: state.viewType,
                  onTap: (document) {
                    DocumentDetailsRoute($extra: document).push(context);
                  },
                  onSelected:
                      context.read<DocumentsCubit>().toggleDocumentSelection,
                  hasInternetConnection: connectivityState.isConnected,
                  onTagSelected: allowToggleFilter ? _addTagToFilter : null,
                  onCorrespondentSelected:
                      allowToggleFilter ? _addCorrespondentToFilter : null,
                  onDocumentTypeSelected:
                      allowToggleFilter ? _addDocumentTypeToFilter : null,
                  onStoragePathSelected:
                      allowToggleFilter ? _addStoragePathToFilter : null,
                  documents: state.documents,
                  hasLoaded: state.hasLoaded,
                  isLabelClickable: true,
                  isLoading: state.isLoading,
                  selectedDocumentIds: state.selectedIds,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewActions() {
    return BlocBuilder<DocumentsCubit, DocumentsState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(4),
          color: Theme.of(context).colorScheme.background,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SortDocumentsButton(
                enabled: state.selection.isEmpty,
              ),
              ViewTypeSelectionWidget(
                viewType: state.viewType,
                onChanged: context.read<DocumentsCubit>().setViewType,
              ),
            ],
          ),
        );
      },
    );
  }

  void _onCreateSavedView(DocumentFilter filter) async {
    //TODO: Implement
    // final newView = await pushAddSavedViewRoute(context, filter: filter);
    // if (newView != null) {
    //   try {
    //     await context.read<SavedViewCubit>().add(newView);
    //   } on PaperlessApiException catch (error, stackTrace) {
    //     showErrorMessage(context, error, stackTrace);
    //   }
    // }
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
          builder: (context, controller) =>
              BlocBuilder<DocumentsCubit, DocumentsState>(
            builder: (context, state) {
              return DocumentFilterPanel(
                initialFilter: context.read<DocumentsCubit>().state.filter,
                scrollController: controller,
                draggableSheetController: draggableSheetController,
                correspondents: state.correspondents,
                documentTypes: state.documentTypes,
                storagePaths: state.storagePaths,
                tags: state.tags,
              );
            },
          ),
        ),
      ),
    );
    if (filterIntent != null) {
      try {
        if (filterIntent.shouldReset) {
          await _onResetFilter();
        } else {
          await context
              .read<DocumentsCubit>()
              .updateFilter(filter: filterIntent.filter!);
        }
      } on PaperlessApiException catch (error, stackTrace) {
        showErrorMessage(context, error, stackTrace);
      }
    }
  }

  void _addTagToFilter(int tagId) {
    final cubit = context.read<DocumentsCubit>();
    try {
      cubit.state.filter.tags.maybeMap(
        ids: (state) {
          if (state.include.contains(tagId)) {
            cubit.updateCurrentFilter(
              (filter) => filter.copyWith(
                tags: state.copyWith(
                  include: state.include
                      .whereNot((element) => element == tagId)
                      .toList(),
                ),
              ),
            );
          } else if (state.exclude.contains(tagId)) {
            cubit.updateCurrentFilter(
              (filter) => filter.copyWith(
                tags: state.copyWith(
                  exclude: state.exclude
                      .whereNot((element) => element == tagId)
                      .toList(),
                ),
              ),
            );
          } else {
            cubit.updateCurrentFilter(
              (filter) => filter.copyWith(
                tags: state.copyWith(include: [...state.include, tagId]),
              ),
            );
          }
        },
        orElse: () {
          cubit.updateCurrentFilter(
            (filter) => filter.copyWith(tags: TagsQuery.ids(include: [tagId])),
          );
        },
      );
    } on PaperlessApiException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  void _addCorrespondentToFilter(int? correspondentId) {
    if (correspondentId == null) return;
    final cubit = context.read<DocumentsCubit>();

    try {
      cubit.state.filter.correspondent.maybeWhen(
        fromId: (id) {
          if (id == correspondentId) {
            cubit.updateCurrentFilter(
              (filter) => filter.copyWith(
                  correspondent: const IdQueryParameter.unset()),
            );
          } else {
            cubit.updateCurrentFilter(
              (filter) => filter.copyWith(
                  correspondent: IdQueryParameter.fromId(correspondentId)),
            );
          }
        },
        orElse: () {
          cubit.updateCurrentFilter(
            (filter) => filter.copyWith(
                correspondent: IdQueryParameter.fromId(correspondentId)),
          );
        },
      );
    } on PaperlessApiException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  void _addDocumentTypeToFilter(int? documentTypeId) {
    if (documentTypeId == null) return;
    final cubit = context.read<DocumentsCubit>();

    try {
      cubit.state.filter.documentType.maybeWhen(
        fromId: (id) {
          if (id == documentTypeId) {
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
        },
        orElse: () {
          cubit.updateCurrentFilter(
            (filter) => filter.copyWith(
                documentType: IdQueryParameter.fromId(documentTypeId)),
          );
        },
      );
    } on PaperlessApiException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  void _addStoragePathToFilter(int? pathId) {
    if (pathId == null) return;
    final cubit = context.read<DocumentsCubit>();

    try {
      cubit.state.filter.storagePath.maybeWhen(
        fromId: (id) {
          if (id == pathId) {
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
        },
        orElse: () {
          cubit.updateCurrentFilter(
            (filter) =>
                filter.copyWith(storagePath: IdQueryParameter.fromId(pathId)),
          );
        },
      );
    } on PaperlessApiException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  Future<void> _onReloadDocuments() async {
    try {
      // We do not await here on purpose so we can show a linear progress indicator below the app bar.
      await Future.wait([
        context.read<DocumentsCubit>().reload(),
        context.read<SavedViewCubit>().reload(),
      ]);
    } on PaperlessApiException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  Future<void> _onResetFilter() async {
    final cubit = context.read<DocumentsCubit>();
    final savedViewCubit = context.read<SavedViewCubit>();
    final activeView = savedViewCubit.state.maybeMap(
      loaded: (state) {
        if (cubit.state.filter.selectedView != null) {
          return state.savedViews[cubit.state.filter.selectedView!];
        }
        return null;
      },
      orElse: () => null,
    );
    final viewHasChanged = activeView != null &&
        activeView.toDocumentFilter() != cubit.state.filter;
    if (viewHasChanged) {
      final discardChanges = await showDialog(
        context: context,
        builder: (context) => const SavedViewChangedDialog(),
      );
      if (discardChanges == true) {
        cubit.resetFilter();
        // Reset
      } else if (discardChanges == false) {
        _updateCurrentSavedView();
      }
    } else {
      cubit.resetFilter();
    }
  }

  Future<void> _updateCurrentSavedView() async {
    final savedViewCubit = context.read<SavedViewCubit>();
    final cubit = context.read<DocumentsCubit>();
    final activeView = savedViewCubit.state.maybeMap(
      loaded: (state) {
        if (cubit.state.filter.selectedView != null) {
          return state.savedViews[cubit.state.filter.selectedView!];
        }
        return null;
      },
      orElse: () => null,
    );
    if (activeView == null) return;
    final newView = activeView.copyWith(
      filterRules: FilterRule.fromFilter(cubit.state.filter),
    );

    await savedViewCubit.update(newView);
    showSnackBar(context, "Saved view successfully updated.");
  }
}
