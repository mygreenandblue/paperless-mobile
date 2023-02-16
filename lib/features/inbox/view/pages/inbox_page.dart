import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/app_drawer/view/app_drawer.dart';
import 'package:paperless_mobile/features/document_search/view/document_search_page.dart';
import 'package:paperless_mobile/core/widgets/hint_card.dart';
import 'package:paperless_mobile/extensions/dart_extensions.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/documents/view/widgets/placeholder/documents_list_loading_widget.dart';
import 'package:paperless_mobile/features/inbox/cubit/inbox_cubit.dart';
import 'package:paperless_mobile/features/inbox/view/widgets/inbox_empty_widget.dart';
import 'package:paperless_mobile/features/inbox/view/widgets/inbox_item.dart';
import 'package:paperless_mobile/features/paged_document_view/view/document_paging_view_mixin.dart';
import 'package:paperless_mobile/features/search_app_bar/view/search_app_bar.dart';
import 'package:paperless_mobile/generated/l10n.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage>
    with DocumentPagingViewMixin<InboxPage, InboxCubit> {
  @override
  final pagingScrollController = ScrollController();
  final _emptyStateRefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    context.read<InboxCubit>().loadInbox();
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaPadding = MediaQuery.of(context).padding;
    final availableHeight = MediaQuery.of(context).size.height -
        kToolbarHeight -
        kBottomNavigationBarHeight -
        safeAreaPadding.top -
        safeAreaPadding.bottom;
    return Scaffold(
      drawer: const AppDrawer(),
      floatingActionButton: BlocBuilder<InboxCubit, InboxState>(
        builder: (context, state) {
          if (!state.hasLoaded || state.documents.isEmpty) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton.extended(
            label: Text(S.of(context).allSeen),
            icon: const Icon(Icons.done_all),
            onPressed: state.hasLoaded && state.documents.isNotEmpty
                ? () => _onMarkAllAsSeen(
                      state.documents,
                      state.inboxTags,
                    )
                : null,
          );
        },
      ),
      body: BlocBuilder<InboxCubit, InboxState>(
        builder: (context, state) {
          return SafeArea(
            top: true,
            child: Builder(
              builder: (context) {
                // Build a list of slivers alternating between SliverToBoxAdapter
                // (group header) and a SliverList (inbox items).
                final List<Widget> slivers = _groupByDate(state.documents)
                    .entries
                    .map(
                      (entry) => [
                        SliverToBoxAdapter(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32.0),
                              child: Text(
                                entry.key,
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ).padded(),
                            ),
                          ).paddedOnly(top: 8.0),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: entry.value.length,
                            (context, index) {
                              if (index < entry.value.length - 1) {
                                return Column(
                                  children: [
                                    _buildListItem(
                                      entry.value[index],
                                    ),
                                    const Divider(
                                      indent: 16,
                                      endIndent: 16,
                                    ),
                                  ],
                                );
                              }
                              return _buildListItem(
                                entry.value[index],
                              );
                            },
                          ),
                        ),
                      ],
                    )
                    .flattened
                    .toList()
                  ..add(const SliverToBoxAdapter(child: SizedBox(height: 78)));
                //                              edgeOffset: kToolbarHeight,

                return RefreshIndicator(
                  edgeOffset: kToolbarHeight,
                  onRefresh: context.read<InboxCubit>().reload,
                  child: CustomScrollView(
                    physics: state.documents.isEmpty
                        ? const NeverScrollableScrollPhysics()
                        : const AlwaysScrollableScrollPhysics(),
                    controller: pagingScrollController,
                    slivers: [
                      SearchAppBar(
                        hintText: S.of(context).searchDocuments,
                        onOpenSearch: showDocumentSearchPage,
                      ),
                      if (state.documents.isEmpty)
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: availableHeight,
                            child: Center(
                              child: InboxEmptyWidget(
                                emptyStateRefreshIndicatorKey:
                                    _emptyStateRefreshIndicatorKey,
                              ),
                            ),
                          ),
                        )
                      else if (!state.hasLoaded)
                        DocumentsListLoadingWidget()
                      else
                        SliverToBoxAdapter(
                          child: HintCard(
                            show: !state.isHintAcknowledged,
                            hintText:
                                S.of(context).swipeLeftToMarkADocumentAsSeen,
                            onHintAcknowledged: () =>
                                context.read<InboxCubit>().acknowledgeHint(),
                          ),
                        ),
                      ...slivers,
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildListItem(DocumentModel doc) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.done_all,
            color: Theme.of(context).colorScheme.primary,
          ).padded(),
          Text(
            S.of(context).markAsSeen,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ).padded(),
      confirmDismiss: (_) => _onItemDismissed(doc),
      key: UniqueKey(),
      child: InboxItem(document: doc),
    );
  }

  Future<void> _onMarkAllAsSeen(
    Iterable<DocumentModel> documents,
    Iterable<int> inboxTags,
  ) async {
    final isActionConfirmed = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(S.of(context).markAllAsSeen),
            content: Text(
              S.of(context).areYouSureYouWantToMarkAllDocumentsAsSeen,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(S.of(context).cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  S.of(context).ok,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        ) ??
        false;
    if (isActionConfirmed) {
      await context.read<InboxCubit>().clearInbox();
    }
  }

  Future<bool> _onItemDismissed(DocumentModel doc) async {
    try {
      final removedTags = await context.read<InboxCubit>().removeFromInbox(doc);
      showSnackBar(
        context,
        S.of(context).removeDocumentFromInbox,
        action: SnackBarActionConfig(
          label: S.of(context).undo,
          onPressed: () => _onUndoMarkAsSeen(doc, removedTags),
        ),
      );
      return true;
    } on PaperlessServerException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
      return false;
    } catch (error) {
      showErrorMessage(
        context,
        const PaperlessServerException.unknown(),
      );
      return false;
    }
  }

  Future<void> _onUndoMarkAsSeen(
    DocumentModel document,
    Iterable<int> removedTags,
  ) async {
    try {
      await context
          .read<InboxCubit>()
          .undoRemoveFromInbox(document, removedTags);
    } on PaperlessServerException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  Map<String, List<DocumentModel>> _groupByDate(
    Iterable<DocumentModel> documents,
  ) {
    return groupBy<DocumentModel, String>(
      documents,
      (doc) {
        if (doc.added.isToday) {
          return S.of(context).today;
        }
        if (doc.added.isYesterday) {
          return S.of(context).yesterday;
        }
        return DateFormat.yMMMMd().format(doc.added);
      },
    );
  }
}
