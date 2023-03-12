import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_bulk_action/cubit/document_bulk_action_cubit.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tag_widget.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tags_form_field.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class BulkEditTagsBottomSheet extends StatefulWidget {
  const BulkEditTagsBottomSheet({super.key});

  @override
  State<BulkEditTagsBottomSheet> createState() =>
      _BulkEditTagsBottomSheetState();
}

class _BulkEditTagsBottomSheetState extends State<BulkEditTagsBottomSheet> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<int> _tagsToRemove = [];
  List<int> _tagsToAdd = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBulkActionCubit, DocumentBulkActionState>(
      builder: (context, state) {
        final sharedTags = state.selection
            .map((doc) => doc.tags)
            .reduce((previousValue, element) =>
                previousValue.toSet().intersection(element.toSet()))
            .toList();
        final nonSharedTags = state.selection
            .map((doc) => doc.tags)
            .flattened
            .toSet()
            .difference(sharedTags.toSet())
            .toList();
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BlocBuilder<DocumentBulkActionCubit, DocumentBulkActionState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Bulk modify tags",
                        style: Theme.of(context).textTheme.titleLarge,
                      ).paddedOnly(bottom: 24),
                      FormBuilder(
                        key: _formKey,
                        child: TagFormField(
                          initialValue: IdsTagsQuery(
                            sharedTags.map((tag) => IncludeTagIdQuery(tag)),
                          ),
                          name: "labelFormField",
                          selectableOptions: state.tagOptions,
                          allowCreation: false,
                          anyAssignedSelectable: false,
                          excludeAllowed: false,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("Tags removed after apply"),
                      Wrap(),
                      const SizedBox(height: 8),
                      Text("Tags added after apply"),
                      Wrap(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const DialogCancelButton(),
                          const SizedBox(width: 16),
                          FilledButton(
                            onPressed: () {
                              if (_formKey.currentState?.saveAndValidate() ??
                                  false) {
                                final value = _formKey.currentState
                                        ?.getRawValue('labelFormField')
                                    as IdsTagsQuery;
                                context
                                    .read<DocumentBulkActionCubit>()
                                    .bulkModifyTags(
                                      addTagIds: value.includedIds,
                                    );
                              }
                            },
                            child: Text(S.of(context)!.apply),
                          ),
                        ],
                      ).padded(8),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
