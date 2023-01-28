import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/documents_list_loading_widget.dart';
import 'package:paperless_mobile/features/document_details/bloc/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/pages/document_details_page.dart';
import 'package:paperless_mobile/features/documents/view/widgets/list/document_list_item.dart';
import 'package:paperless_mobile/features/linked_documents/bloc/linked_documents_cubit.dart';
import 'package:paperless_mobile/features/linked_documents/bloc/state/linked_documents_state.dart';
import 'package:paperless_mobile/generated/l10n.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class LinkedDocumentsPage extends StatefulWidget {
  const LinkedDocumentsPage({super.key});

  @override
  State<LinkedDocumentsPage> createState() => _LinkedDocumentsPageState();
}

class _LinkedDocumentsPageState extends State<LinkedDocumentsPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listenForLoadNewData);
  }

  void _listenForLoadNewData() async {
    final currState = context.read<LinkedDocumentsCubit>().state;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent * 0.75 &&
        !currState.isLoading &&
        !currState.isLastPageLoaded) {
      try {
        await context.read<LinkedDocumentsCubit>().loadMore();
      } on PaperlessServerException catch (error, stackTrace) {
        showErrorMessage(context, error, stackTrace);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).linkedDocumentsPageTitle),
      ),
      body: BlocBuilder<LinkedDocumentsCubit, LinkedDocumentsState>(
        builder: (context, state) {
          if (!state.hasLoaded) {
            return const DocumentsListLoadingWidget();
          }
          return ListView.builder(
            itemCount: state.documents.length,
            itemBuilder: (context, index) => DocumentListItem(
              document: state.documents[index],
            ),
          );
        },
      ),
    );
  }
}
