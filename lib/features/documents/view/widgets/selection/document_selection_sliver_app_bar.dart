import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/bulk_delete_confirmation_dialog.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_correspondent_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_document_type_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_storage_path_page.dart';
import 'package:paperless_mobile/features/labels/cubit/label_cubit.dart';
import 'package:paperless_mobile/features/labels/cubit/providers/correspondent_bloc_provider.dart';
import 'package:paperless_mobile/features/labels/cubit/providers/document_type_bloc_provider.dart';
import 'package:paperless_mobile/features/labels/cubit/providers/labels_bloc_provider.dart';
import 'package:paperless_mobile/features/labels/cubit/providers/storage_path_bloc_provider.dart';
import 'package:paperless_mobile/features/labels/view/widgets/label_form_field.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:provider/provider.dart';

class DocumentSelectionSliverAppBar extends StatelessWidget {
  final DocumentsState state;
  const DocumentSelectionSliverAppBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
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
        preferredSize: Size.fromHeight(kTextTabBarHeight),
        child: SizedBox(
          height: kTextTabBarHeight,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildBulkEditCorrespondentChip(context)
                  .paddedOnly(left: 8, right: 8),
              _buildBulkEditDocumentTypeChip(context).paddedOnly(right: 8),
              _buildBulkEditTagChip(context).paddedOnly(right: 8),
              _buildBulkEditStoragePathChip(context).paddedOnly(right: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulkEditCorrespondentChip(BuildContext context) {
    return ActionChip(
      label: Text(S.of(context)!.correspondent),
      avatar: Icon(Icons.edit),
      onPressed: () {
        final _formKey = GlobalKey<FormBuilderState>();
        final initialValue = state.selection.every((element) =>
                element.correspondent == state.selection.first.correspondent)
            ? IdQueryParameter.fromId(state.selection.first.correspondent)
            : const IdQueryParameter.unset();
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
            return BulkEditBottomSheet(
              formKey: _formKey,
              formFieldName: "correspondent",
              initialValue: initialValue,
              selectedIds: state.selectedIds,
              actionBuilder: (int? id) => BulkModifyLabelAction.correspondent(
                state.selectedIds,
                labelId: id,
              ),
              formField: CorrespondentBlocProvider(
                child: BlocBuilder<LabelCubit<Correspondent>,
                    LabelState<Correspondent>>(
                  builder: (context, state) {
                    return LabelFormField<Correspondent>(
                      name: "correspondent",
                      initialValue: initialValue,
                      notAssignedSelectable: false,
                      labelCreationWidgetBuilder: (initialName) {
                        return AddCorrespondentPage(
                          initialName: initialName,
                        );
                      },
                      labelOptions: state.labels,
                      textFieldLabel: "Correspondent",
                      formBuilderState: _formKey.currentState,
                      prefixIcon: const Icon(Icons.person),
                    ).padded();
                  },
                ),
              ),
              onQuerySubmitted: context.read<DocumentsCubit>().bulkAction,
              title: 'Bulk edit correspondent',
            );
          },
        );
      },
    );
  }

  Widget _buildBulkEditDocumentTypeChip(BuildContext context) {
    return ActionChip(
      label: Text(S.of(context)!.documentType),
      avatar: Icon(Icons.edit),
      onPressed: () {
        final _formKey = GlobalKey<FormBuilderState>();
        final initialValue = state.selection.every((element) =>
                element.documentType == state.selection.first.documentType)
            ? IdQueryParameter.fromId(state.selection.first.documentType)
            : const IdQueryParameter.unset();
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
            return BulkEditBottomSheet(
              formKey: _formKey,
              formFieldName: "documentType",
              initialValue: initialValue,
              selectedIds: state.selectedIds,
              actionBuilder: (int? id) => BulkModifyLabelAction.documentType(
                state.selectedIds,
                labelId: id,
              ),
              formField: DocumentTypeBlocProvider(
                child: BlocBuilder<LabelCubit<DocumentType>,
                    LabelState<DocumentType>>(
                  builder: (context, state) {
                    return LabelFormField<DocumentType>(
                      name: "documentType",
                      initialValue: initialValue,
                      notAssignedSelectable: false,
                      labelCreationWidgetBuilder: (initialName) {
                        return AddDocumentTypePage(
                          initialName: initialName,
                        );
                      },
                      labelOptions: state.labels,
                      textFieldLabel: S.of(context)!.documentType,
                      formBuilderState: _formKey.currentState,
                      prefixIcon: const Icon(Icons.person),
                    ).padded();
                  },
                ),
              ),
              onQuerySubmitted: context.read<DocumentsCubit>().bulkAction,
              title: 'Bulk edit document type',
            );
          },
        );
      },
    );
  }

  Widget _buildBulkEditTagChip(BuildContext context) {
    return ActionChip(
      label: Text(S.of(context)!.correspondent),
      avatar: Icon(Icons.edit),
      onPressed: () {
        final _formKey = GlobalKey<FormBuilderState>();
        final initialValue = state.selection.every((element) =>
                element.correspondent == state.selection.first.correspondent)
            ? IdQueryParameter.fromId(state.selection.first.correspondent)
            : const IdQueryParameter.unset();
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
            return BulkEditBottomSheet(
              formKey: _formKey,
              formFieldName: "correspondent",
              initialValue: initialValue,
              selectedIds: state.selectedIds,
              actionBuilder: (int? id) => BulkModifyLabelAction.correspondent(
                state.selectedIds,
                labelId: id,
              ),
              formField: CorrespondentBlocProvider(
                child: BlocBuilder<LabelCubit<Correspondent>,
                    LabelState<Correspondent>>(
                  builder: (context, state) {
                    return LabelFormField<Correspondent>(
                      name: "correspondent",
                      initialValue: initialValue,
                      notAssignedSelectable: false,
                      labelCreationWidgetBuilder: (initialName) {
                        return AddCorrespondentPage(
                          initialName: initialName,
                        );
                      },
                      labelOptions: state.labels,
                      textFieldLabel: "Correspondent",
                      formBuilderState: _formKey.currentState,
                      prefixIcon: const Icon(Icons.person),
                    ).padded();
                  },
                ),
              ),
              onQuerySubmitted: context.read<DocumentsCubit>().bulkAction,
              title: 'Bulk edit correspondent',
            );
          },
        );
      },
    );
  }

  Widget _buildBulkEditStoragePathChip(BuildContext context) {
    return ActionChip(
      label: Text(S.of(context)!.storagePath),
      avatar: Icon(Icons.edit),
      onPressed: () {
        final _formKey = GlobalKey<FormBuilderState>();
        final initialValue = state.selection.every((element) =>
                element.storagePath == state.selection.first.storagePath)
            ? IdQueryParameter.fromId(state.selection.first.storagePath)
            : const IdQueryParameter.unset();
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
            return BulkEditBottomSheet(
              formKey: _formKey,
              formFieldName: "storagePath",
              initialValue: initialValue,
              selectedIds: state.selectedIds,
              actionBuilder: (int? id) => BulkModifyLabelAction.storagePath(
                state.selectedIds,
                labelId: id,
              ),
              formField: StoragePathBlocProvider(
                child: BlocBuilder<LabelCubit<StoragePath>,
                    LabelState<StoragePath>>(
                  builder: (context, state) {
                    return LabelFormField<StoragePath>(
                      name: "storagePath",
                      initialValue: initialValue,
                      notAssignedSelectable: false,
                      labelCreationWidgetBuilder: (initialName) {
                        return AddStoragePathPage(
                          initalName: initialName,
                        );
                      },
                      labelOptions: state.labels,
                      textFieldLabel: S.of(context)!.storagePath,
                      formBuilderState: _formKey.currentState,
                      prefixIcon: const Icon(Icons.person),
                    ).padded();
                  },
                ),
              ),
              onQuerySubmitted: context.read<DocumentsCubit>().bulkAction,
              title: 'Bulk edit storage path',
            );
          },
        );
      },
    );
  }
}

class BulkEditBottomSheet extends StatefulWidget {
  final Future<void> Function(BulkAction action) onQuerySubmitted;
  final List<int> selectedIds;
  final IdQueryParameter initialValue;
  final String title;
  final Widget formField;
  final String formFieldName;
  final BulkAction Function(int? id) actionBuilder;
  final GlobalKey<FormBuilderState> formKey;
  const BulkEditBottomSheet({
    super.key,
    required this.initialValue,
    required this.onQuerySubmitted,
    required this.selectedIds,
    required this.title,
    required this.formField,
    required this.formFieldName,
    required this.actionBuilder,
    required this.formKey,
  });

  @override
  State<BulkEditBottomSheet> createState() => _BulkEditBottomSheetState();
}

class _BulkEditBottomSheetState extends State<BulkEditBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ).padded(16),
          FormBuilder(
            key: widget.formKey,
            child: widget.formField,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const DialogCancelButton().paddedOnly(right: 8),
                FilledButton(
                  child: Text(S.of(context)!.apply),
                  onPressed: () async {
                    if (widget.formKey.currentState?.saveAndValidate() ??
                        false) {
                      final value = widget
                          .formKey
                          .currentState!
                          .fields[widget.formFieldName]
                          ?.value as IdQueryParameter;
                      final id = value.id;
                      await widget.onQuerySubmitted(widget.actionBuilder(id));
                      Navigator.of(context).pop();
                      showSnackBar(
                        context,
                        "Documents successfully edited.",
                      );
                    }
                  },
                ),
              ],
            ).padded(16),
          ),
        ],
      ),
    );
  }
}
