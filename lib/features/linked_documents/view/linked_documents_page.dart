import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/features/documents/view/widgets/adaptive_documents_view.dart';
import 'package:paperless_mobile/features/linked_documents/cubit/linked_documents_cubit.dart';
import 'package:paperless_mobile/generated/l10n.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routes/document_details_route.dart';

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
          return BlocBuilder<ConnectivityCubit, ConnectivityState>(
            builder: (context, connectivity) {
              return DefaultAdaptiveDocumentsView(
                scrollController: _scrollController,
                documents: state.documents,
                hasInternetConnection: connectivity.isConnected,
                isLabelClickable: false,
                isLoading: state.isLoading,
                hasLoaded: state.hasLoaded,
                onTap: (document) {
                  Navigator.pushNamed(
                    context,
                    DocumentDetailsRoute.routeName,
                    arguments: DocumentDetailsRouteArguments(
                      document: document,
                      isLabelClickable: false,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
