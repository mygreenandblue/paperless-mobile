import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_bulk_action/cubit/document_bulk_action_cubit.dart';
import 'package:paperless_mobile/features/labels/view/widgets/label_form_field.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class BulkEditLabelBottomSheet<T extends Label> extends StatefulWidget {
  final String title;
  final String formFieldLabel;
  final Widget formFieldPrefixIcon;
  final Map<int, T> Function(DocumentBulkActionState state)
      availableOptionsSelector;
  final void Function(int? selectedId) onSubmit;
  final int? initialValue;
  const BulkEditLabelBottomSheet({
    super.key,
    required this.title,
    required this.formFieldLabel,
    required this.formFieldPrefixIcon,
    required this.availableOptionsSelector,
    required this.onSubmit,
    this.initialValue,
  });

  @override
  State<BulkEditLabelBottomSheet<T>> createState() =>
      _BulkEditLabelBottomSheetState<T>();
}

class _BulkEditLabelBottomSheetState<T extends Label>
    extends State<BulkEditLabelBottomSheet<T>> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
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
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ).paddedOnly(bottom: 24),
                  FormBuilder(
                    key: _formKey,
                    child: LabelFormField<T>(
                      initialValue:
                          IdQueryParameter.fromId(widget.initialValue),
                      name: "labelFormField",
                      options: widget.availableOptionsSelector(state),
                      labelText: widget.formFieldLabel,
                      prefixIcon: widget.formFieldPrefixIcon,
                    ),
                  ),
                  const SizedBox(height: 8),
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
                                as IdQueryParameter?;
                            widget.onSubmit(value?.id);
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
  }
}
