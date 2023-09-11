import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:paperless_mobile/features/documents/view/widgets/items/document_list_item.dart';
import 'package:paperless_mobile/features/landing/view/widgets/expansion_card.dart';
import 'package:paperless_mobile/features/saved_view_details/cubit/saved_view_preview_cubit.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routes/typed/branches/documents_route.dart';
import 'package:provider/provider.dart';

class SavedViewPreview extends StatelessWidget {
  final SavedView savedView;
  const SavedViewPreview({
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
          initiallyExpanded: true,
          title: Text(savedView.name),
          content: BlocBuilder<SavedViewPreviewCubit, SavedViewPreviewState>(
            builder: (context, state) {
              return state.maybeWhen(
                loaded: (documents) {
                  return Column(
                    children: [
                      if (documents.isEmpty)
                        Text("This view is empty.").padded()
                      else
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.open_in_new),
                            label: Text("Show all"), //TODO: INTL
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
                error: () => const Text("Error loading preview"), //TODO: INTL
                orElse: () => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
