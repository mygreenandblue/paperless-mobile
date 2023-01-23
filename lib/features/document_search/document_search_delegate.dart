import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/provider/label_repositories_provider.dart';
import 'package:paperless_mobile/core/widgets/documents_list_loading_widget.dart';
import 'package:paperless_mobile/features/document_details/bloc/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/pages/document_details_page.dart';
import 'package:paperless_mobile/features/document_search/cubit/document_search_cubit.dart';
import 'package:paperless_mobile/features/document_search/cubit/document_search_state.dart';
import 'package:paperless_mobile/features/documents/view/widgets/list/document_list_item.dart';
import 'package:provider/provider.dart';

class DocumentSearchDelegate extends SearchDelegate<DocumentModel> {
  DocumentSearchDelegate({
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
  Widget buildSuggestions(BuildContext context) {
    BlocBuilder<DocumentSearchCubit, DocumentSearchState>(
      builder: (context, state) {
        if (!state.hasLoaded && state.isLoading)  {
          return const DocumentsListLoadingWidget(); 
        }
        return ListView.builder(itemBuilder: (context, index) => ListTile(
            title: Text(snapshot.data![index]),
            onTap: () {
              query = snapshot.data![index];
              super.showResults(context);
            },
          ),);
      },
    )
    return FutureBuilder(
      future: context.read<PaperlessDocumentsApi>().autocomplete(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(snapshot.data![index]),
            onTap: () {
              query = snapshot.data![index];
              super.showResults(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: context
          .read<PaperlessDocumentsApi>()
          .findAll(DocumentFilter(query: TextQuery.titleAndContent(query))),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = snapshot.data!.results;
        return ListView.builder(
          itemBuilder: (context, index) => DocumentListItem(
            document: documents[index],
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
  List<Widget> buildActions(BuildContext context) => <Widget>[];
}
