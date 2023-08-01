import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:paperless_mobile/features/documents/view/widgets/adaptive_documents_view.dart';
import 'package:paperless_mobile/features/documents/view/widgets/items/document_list_item.dart';
import 'package:paperless_mobile/features/landing/view/widgets/expansion_card.dart';
import 'package:paperless_mobile/features/saved_view_details/cubit/saved_view_details_cubit.dart';
import 'package:paperless_mobile/features/saved_view_details/cubit/saved_view_preview_cubit.dart';
import 'package:paperless_mobile/routes/typed/branches/documents_route.dart';
import 'package:provider/provider.dart';

class SavedViewDetailsPreview extends StatelessWidget {
  final SavedView savedView;
  const SavedViewDetailsPreview({
    super.key,
    required this.savedView,
  });

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) =>
          SavedViewPreviewCubit(context.read(), savedView)..initialize(),
      builder: (context, child) {
        return ExpansionCard(
          title: Text(savedView.name),
          content: BlocBuilder<SavedViewPreviewCubit, SavedViewPreviewState>(
            builder: (context, state) {
              return Column(
                children: [
                  state.maybeWhen(
                    loaded: (documents) {
                      return Column(
                        children: [
                          for (final document in documents)
                            DocumentListItem(
                              document: document,
                              isLabelClickable: false,
                              isSelected: false,
                              isSelectionActive: false,
                              onTap: (document) {
                                DocumentDetailsRoute($extra: document)
                                    .push(context);
                              },
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                child: Text("Show more"),
                                onPressed: documents.length >= 5 ? () {} : null,
                              ),
                              TextButton.icon(
                                icon: Icon(Icons.open_in_new),
                                label: Text("Show in documents"),
                                onPressed: () {
                                  context.read<DocumentsCubit>().updateFilter(
                                        filter: savedView.toDocumentFilter(),
                                      );
                                  DocumentsRoute().go(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    error: () =>
                        const Text("Error loading preview"), //TODO: INTL
                    orElse: () => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
