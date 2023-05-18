import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/navigation/push_routes.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_search/cubit/document_search_cubit.dart';
import 'package:paperless_mobile/features/document_search/view/remove_history_entry_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/adaptive_documents_view.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/view_type_selection_widget.dart';
import 'package:paperless_mobile/features/home/view/model/api_version.dart';
import 'package:paperless_mobile/features/settings/model/view_type.dart';
import 'package:paperless_mobile/features/settings/view/manage_accounts_page.dart';
import 'package:paperless_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:paperless_mobile/features/settings/view/widgets/user_avatar.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DocumentSearchBar extends StatefulWidget {
  const DocumentSearchBar({super.key});

  @override
  State<DocumentSearchBar> createState() => _DocumentSearchBarState();
}

class _DocumentSearchBarState extends State<DocumentSearchBar> {
  Timer? _debounceTimer;

  final _controller = SearchController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        context.read<DocumentSearchCubit>().suggest(query);
      });
    });
  }

  late final DocumentSearchCubit _searchCubit;
  String get query => _controller.text;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchCubit = context.watch<DocumentSearchCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      searchController: _controller,
      barLeading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: Scaffold.of(context).openDrawer,
      ),
      barHintText: S.of(context)!.searchDocuments,
      barTrailing: [
        IconButton(
          icon: GlobalSettingsBuilder(
            builder: (context, settings) {
              return ValueListenableBuilder(
                valueListenable:
                    Hive.box<LocalUserAccount>(HiveBoxes.localUserAccount).listenable(),
                builder: (context, box, _) {
                  final account = box.get(settings.currentLoggedInUser!)!;
                  return UserAvatar(
                    userId: settings.currentLoggedInUser!,
                    account: account,
                  );
                },
              );
            },
          ),
          onPressed: () {
            final apiVersion = context.read<ApiVersion>();
            showDialog(
              context: context,
              builder: (context) => Provider.value(
                value: apiVersion,
                child: const ManageAccountsPage(),
              ),
            );
          },
        ),
      ],
      suggestionsBuilder: (context, controller) {
        switch (_searchCubit.state.view) {
          case SearchView.suggestions:
            return _buildSuggestionItems(_searchCubit.state);
          case SearchView.results:
            // TODO: Handle this case.
            break;
        }
      },
    );
  }

  Iterable<Widget> _buildSuggestionItems(DocumentSearchState state) sync* {
    final suggestions =
        state.suggestions.whereNot((element) => state.searchHistory.contains(element));
    final historyMatches = state.searchHistory.where((element) => element.startsWith(query));
    for (var match in historyMatches.take(5)) {
      yield ListTile(
        title: Text(match),
        leading: const Icon(Icons.history),
        onLongPress: () => _onDeleteHistoryEntry(match),
        onTap: () => _selectSuggestion(match),
        trailing: _buildInsertSuggestionButton(match),
      );
    }

    for (var suggestion in suggestions) {
      yield ListTile(
        title: Text(suggestion),
        leading: const Icon(Icons.search),
        onTap: () => _selectSuggestion(suggestion),
        trailing: _buildInsertSuggestionButton(suggestion),
      );
    }
  }

  void _onDeleteHistoryEntry(String entry) async {
    final shouldRemove = await showDialog<bool>(
          context: context,
          builder: (context) => RemoveHistoryEntryDialog(entry: entry),
        ) ??
        false;
    if (shouldRemove) {
      context.read<DocumentSearchCubit>().removeHistoryEntry(entry);
    }
  }

  Widget _buildInsertSuggestionButton(String suggestion) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(math.pi),
      child: IconButton(
        icon: const Icon(Icons.arrow_outward),
        onPressed: () {
          _controller.text = '$suggestion ';
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        },
      ),
    );
  }

  Widget _buildResultsView(DocumentSearchState state) {
    final header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.of(context)!.results,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        BlocBuilder<DocumentSearchCubit, DocumentSearchState>(
          builder: (context, state) {
            return ViewTypeSelectionWidget(
              viewType: state.viewType,
              onChanged: (type) => context.read<DocumentSearchCubit>().updateViewType(type),
            );
          },
        )
      ],
    ).padded();
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: header),
        if (state.hasLoaded && !state.isLoading && state.documents.isEmpty)
          SliverToBoxAdapter(
            child: Center(
              child: Text(S.of(context)!.noMatchesFound),
            ),
          )
        else
          SliverAdaptiveDocumentsView(
            viewType: state.viewType,
            documents: state.documents,
            hasInternetConnection: true,
            isLabelClickable: false,
            isLoading: state.isLoading,
            hasLoaded: state.hasLoaded,
            enableHeroAnimation: false,
            onTap: (document) {
              pushDocumentDetailsRoute(
                context,
                document: document,
                isLabelClickable: false,
              );
            },
          )
      ],
    );
  }

  void _selectSuggestion(String suggestion) {
    _controller.text = suggestion;
    context.read<DocumentSearchCubit>().search(suggestion);
    FocusScope.of(context).unfocus();
  }
}
