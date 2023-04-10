import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_bulk_action/cubit/document_bulk_action_cubit.dart';
import 'package:paperless_mobile/features/document_bulk_action/view/widgets/bulk_edit_label_bottom_sheet.dart';
import 'package:paperless_mobile/features/document_bulk_action/view/widgets/bulk_edit_tags_bottom_sheet.dart';
import 'package:paperless_mobile/features/document_bulk_action/view/widgets/fullscreen_bulk_edit_label_form_field.dart';
import 'package:paperless_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/bulk_delete_confirmation_dialog.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class DocumentSelectionSliverAppBar extends StatelessWidget {
  final DocumentsState state;
  const DocumentSelectionSliverAppBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      stretch: false,
      pinned: true,
      floating: true,
      snap: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      title: Text(
        S.of(context)!.countSelected(state.selection.length),
      ),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => context.read<DocumentsCubit>().resetSelection(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) =>
                      BulkDeleteConfirmationDialog(state: state),
                ) ??
                false;
            if (shouldDelete) {
              try {
                await context
                    .read<DocumentsCubit>()
                    .bulkDelete(state.selection);
                showSnackBar(
                  context,
                  S.of(context)!.documentsSuccessfullyDeleted,
                );
                context.read<DocumentsCubit>().resetSelection();
              } on PaperlessServerException catch (error, stackTrace) {
                showErrorMessage(context, error, stackTrace);
              }
            }
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kTextTabBarHeight),
        child: SizedBox(
          height: kTextTabBarHeight,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ActionChip(
                label: Text(S.of(context)!.correspondent),
                avatar: const Icon(Icons.edit),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => DocumentBulkActionCubit(
                          context.read(),
                          context.read(),
                          context.read(),
                          selection: state.selection,
                        ),
                        child: BlocBuilder<DocumentBulkActionCubit,
                            DocumentBulkActionState>(
                          builder: (context, state) {
                            return FullscreenBulkEditLabelFormField(
                              options: state.correspondents,
                              selection: state.selection,
                              labelMapper: (document) => document.correspondent,
                              leadingIcon: const Icon(Icons.person_outline),
                              hintText: S.of(context)!.startTyping,
                              onSubmit: context
                                  .read<DocumentBulkActionCubit>()
                                  .bulkModifyCorrespondent,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ).paddedOnly(left: 8, right: 4),
              ActionChip(
                label: Text(S.of(context)!.documentType),
                avatar: const Icon(Icons.edit),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => DocumentBulkActionCubit(
                          context.read(),
                          context.read(),
                          context.read(),
                          selection: state.selection,
                        ),
                        child: BlocBuilder<DocumentBulkActionCubit,
                            DocumentBulkActionState>(
                          builder: (context, state) {
                            return FullscreenBulkEditLabelFormField(
                              options: state.documentTypes,
                              selection: state.selection,
                              labelMapper: (document) => document.documentType,
                              leadingIcon:
                                  const Icon(Icons.description_outlined),
                              hintText: S.of(context)!.startTyping,
                              onSubmit: context
                                  .read<DocumentBulkActionCubit>()
                                  .bulkModifyDocumentType,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ).paddedOnly(left: 8, right: 4),
              ActionChip(
                label: Text(S.of(context)!.storagePath),
                avatar: const Icon(Icons.edit),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => DocumentBulkActionCubit(
                          context.read(),
                          context.read(),
                          context.read(),
                          selection: state.selection,
                        ),
                        child: BlocBuilder<DocumentBulkActionCubit,
                            DocumentBulkActionState>(
                          builder: (context, state) {
                            return FullscreenBulkEditLabelFormField(
                              options: state.storagePaths,
                              selection: state.selection,
                              labelMapper: (document) => document.storagePath,
                              leadingIcon: const Icon(Icons.folder_outlined),
                              hintText: S.of(context)!.startTyping,
                              onSubmit: context
                                  .read<DocumentBulkActionCubit>()
                                  .bulkModifyStoragePath,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ).paddedOnly(left: 8, right: 4),
              _buildBulkEditTagsChip(context).paddedOnly(left: 4, right: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulkEditTagsChip(BuildContext context) {
    return ActionChip(
      label: Text(S.of(context)!.tags),
      avatar: const Icon(Icons.edit),
      onPressed: () {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          isScrollControlled: true,
          context: context,
          builder: (_) {
            return BlocProvider(
              create: (context) => DocumentBulkActionCubit(
                context.read(),
                context.read(),
                context.read(),
                selection: state.selection,
              ),
              child: Builder(builder: (context) {
                return const BulkEditTagsBottomSheet();
              }),
            );
          },
        );
      },
    );
  }
}
