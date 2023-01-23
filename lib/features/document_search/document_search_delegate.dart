import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/provider/label_repositories_provider.dart';
import 'package:paperless_mobile/core/widgets/documents_list_loading_widget.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_details/bloc/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/pages/document_details_page.dart';
import 'package:paperless_mobile/features/document_search/cubit/document_search_cubit.dart';
import 'package:paperless_mobile/features/document_search/cubit/document_search_state.dart';
import 'package:paperless_mobile/features/documents/view/widgets/list/document_list_item.dart';

import 'package:paperless_mobile/core/widgets/material/search/m3_search.dart'
    as m3;
import 'package:paperless_mobile/generated/l10n.dart';

class DocumentSearchDelegate extends m3.SearchDelegate<DocumentModel> {
  final DocumentSearchCubit bloc;
  DocumentSearchDelegate(
    this.bloc, {
    required String hintText,
    required super.searchFieldStyle,
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  Widget buildLeading(BuildContext context) => const BackButton();

  @override
  PreferredSizeWidget buildBottom(BuildContext context) => PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          color: Theme.of(context).colorScheme.outline,
          height: 1,
        ),
      );
  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<DocumentSearchCubit, DocumentSearchState>(
      bloc: bloc,
      builder: (context, state) {
        if (query.isEmpty) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Text(
                  "History", //TODO: INTL
                  style: Theme.of(context).textTheme.labelMedium,
                ).padded(16),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final label = state.searchHistory[index];
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(label),
                      onTap: () => _onSuggestionSelected(
                        context,
                        label,
                      ),
                      onLongPress: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(label),
                          content: Text(
                            S.of(context).documentSearchPageRemoveFromHistory,
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                S.of(context).genericActionCancelLabel,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                              child: Text(
                                S.of(context).genericActionDeleteLabel,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              onPressed: () {
                                bloc.removeHistoryEntry(label);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: state.searchHistory.length,
                ),
              ),
            ],
          );
        }
        return FutureBuilder<List<String>>(
            future: bloc.findSuggestions(query),
            builder: (context, snapshot) {
              final historyMatches = state.searchHistory
                  .where((e) => e.startsWith(query))
                  .toList();
              final serverSuggestions = (snapshot.data ?? [])
                ..removeWhere((e) => historyMatches.contains(e));
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Text(
                      "Results", //TODO: INTL
                      style: Theme.of(context).textTheme.labelMedium,
                    ).padded(),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(
                        title: Text(historyMatches[index]),
                        leading: const Icon(Icons.history),
                        onTap: () => _onSuggestionSelected(
                          context,
                          historyMatches[index],
                        ),
                      ),
                      childCount: historyMatches.length,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(
                        title: Text(serverSuggestions[index]),
                        leading: const Icon(Icons.search),
                        onTap: () => _onSuggestionSelected(
                            context, snapshot.data![index]),
                      ),
                      childCount: serverSuggestions.length,
                    ),
                  ),
                ],
              );
            });
      },
    );
  }

  void _onSuggestionSelected(BuildContext context, String suggestion) {
    query = suggestion;
    bloc.updateResults(query);
    super.showResults(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<DocumentSearchCubit, DocumentSearchState>(
      bloc: bloc,
      builder: (context, state) {
        if (!state.hasLoaded && state.isLoading) {
          return const DocumentsListLoadingWidget();
        }
        return ListView.builder(
          itemCount: state.documents.length,
          itemBuilder: (context, index) => DocumentListItem(
            document: state.documents[index],
            onTap: (document) {
              Navigator.push<DocumentModel?>(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => DocumentDetailsCubit(
                      context.read<PaperlessDocumentsApi>(),
                      document,
                    ),
                    child: const LabelRepositoriesProvider(
                      child: DocumentDetailsPage(
                        isLabelClickable: false,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ).paddedSymmetrically(horizontal: 16),
        onPressed: () {
          query = '';
          super.showSuggestions(context);
        },
      ),
    ];
  }
}
