import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/core/widgets/documents_list_loading_widget.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/documents/view/widgets/list/document_list_item.dart';
import 'package:paperless_mobile/features/search/cubit/document_search_state.dart';
import 'package:paperless_mobile/features/search/cubit/document_search_cubit.dart';
import 'package:paperless_mobile/generated/l10n.dart';

Future<void> showDocumentSearchPage(BuildContext context) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => DocumentSearchCubit(context.read()),
        child: const DocumentSearchPage(),
      ),
    ),
  );
}

class DocumentSearchPage extends StatefulWidget {
  const DocumentSearchPage({super.key});

  @override
  State<DocumentSearchPage> createState() => _DocumentSearchPageState();
}

class _DocumentSearchPageState extends State<DocumentSearchPage> {
  final _queryController = TextEditingController(text: '');

  String get query => _queryController.text;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        toolbarHeight: 72,
        leading: BackButton(
          color: theme.colorScheme.onSurface,
        ),
        title: TextField(
          autofocus: true,
          style: theme.textTheme.bodyLarge?.apply(
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintStyle: theme.textTheme.bodyLarge?.apply(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            hintText: "Search documents",
            border: InputBorder.none,
          ),
          controller: _queryController,
          onChanged: context.read<DocumentSearchCubit>().suggest,
          onSubmitted: context.read<DocumentSearchCubit>().search,
        ),
        actions: [
          IconButton(
            color: theme.colorScheme.onSurfaceVariant,
            icon: Icon(Icons.clear),
            onPressed: () {
              context.read<DocumentSearchCubit>().reset();
              _queryController.clear();
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            color: theme.colorScheme.outline,
          ),
        ),
      ),
      body: BlocBuilder<DocumentSearchCubit, DocumentSearchState>(
        builder: (context, state) {
          switch (state.view) {
            case SearchView.suggestions:
              return _buildSuggestionsView(state);
            case SearchView.results:
              return _buildResultsView(state);
          }
        },
      ),
    );
  }

  Widget _buildSuggestionsView(DocumentSearchState state) {
    final suggestions = state.suggestions
        .whereNot((element) => state.searchHistory.contains(element))
        .toList();
    final historyMatches = state.searchHistory
        .where(
          (element) => element.startsWith(query),
        )
        .toList();
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ListTile(
              title: Text(historyMatches[index]),
              leading: Icon(Icons.history),
              onTap: () => _selectSuggestion(historyMatches[index]),
            ),
            childCount: historyMatches.length,
          ),
        ),
        if (state.isLoading)
          const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text(suggestions[index]),
                leading: Icon(Icons.search),
                onTap: () => _selectSuggestion(suggestions[index]),
              ),
              childCount: suggestions.length,
            ),
          )
      ],
    );
  }

  Widget _buildResultsView(DocumentSearchState state) {
    final header = Text(
      S.of(context).documentSearchResults,
      style: Theme.of(context).textTheme.labelSmall,
    ).padded();
    if (state.isLoading) {
      return DocumentsListLoadingWidget(
        beforeWidgets: [header],
      );
    }
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: header),
        if (state.hasLoaded && !state.isLoading && state.documents.isEmpty)
          SliverToBoxAdapter(
            child: Center(child: Text("No documents found.")),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => DocumentListItem(
                document: state.documents[index],
              ),
              childCount: state.documents.length,
            ),
          ),
      ],
    );
  }

  void _selectSuggestion(String suggestion) {
    context.read<DocumentSearchCubit>().search(suggestion);
  }
}
