import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/core/widgets/form_fields/fullscreen_selection_form.dart';
import 'package:paperless_mobile/features/document_bulk_action/cubit/document_bulk_action_cubit.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class FullscreenBulkEditLabelFormField extends StatefulWidget {
  final String hintText;
  final Map<int, Label> options;
  final List<DocumentModel> selection;
  final int? Function(DocumentModel document) labelMapper;
  final Widget leadingIcon;
  final void Function(int? id) onSubmit;

  FullscreenBulkEditLabelFormField({
    super.key,
    required this.options,
    required this.selection,
    required this.labelMapper,
    required this.leadingIcon,
    required this.hintText,
    required this.onSubmit,
  }) : assert(selection.isNotEmpty);

  @override
  State<FullscreenBulkEditLabelFormField> createState() =>
      _FullscreenBulkEditLabelFormFieldState();
}

class _FullscreenBulkEditLabelFormFieldState<T extends Label>
    extends State<FullscreenBulkEditLabelFormField> {
  LabelSelection? _selection;

  @override
  void initState() {
    super.initState();
    if (_initialValues.length == 1 && _initialValues.first != null) {
      _selection = LabelSelection(_initialValues.first);
    }
  }

  List<int?> get _initialValues =>
      widget.selection.map(widget.labelMapper).toSet().toList();

  Iterable<int> _generateOrderedLabels() sync* {
    for (var label in _initialValues) {
      if (label != null) {
        yield label;
      }
    }
    for (final id
        in widget.options.keys.whereNot((e) => _initialValues.contains(e))) {
      yield id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _labels = _generateOrderedLabels();
    final hideFab = _selection == null ||
        (_initialValues.length == 1 &&
            _selection?.label == _initialValues.first);
    return FullscreenSelectionForm(
      hintText: widget.hintText,
      leadingIcon: widget.leadingIcon,
      selectionBuilder: (context, index) =>
          _buildItem(widget.options[_labels.elementAt(index)]!),
      selectionCount: _labels.length,
      floatingActionButton: !hideFab
          ? FloatingActionButton.extended(
              onPressed: () async {
                if (_selection == null) {
                  Navigator.pop(context);
                } else {
                  final shouldPerformAction = await showDialog<bool>(
                        context: context,
                        builder: (context) => _buildConfirmDialog(context),
                        // if _selection.labelId is null: show dialog asking to remove label from widget.selection.length documents
                        // else show dialog asking to assign label to widget.selection.length documents
                      ) ??
                      false;
                  if (shouldPerformAction) {
                    widget.onSubmit(_selection!.label);
                    Navigator.pop(context);
                  }
                }
              },
              label: Text(S.of(context)!.apply),
              icon: Icon(Icons.done),
            )
          : null,
    );
  }

  AlertDialog _buildConfirmDialog(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context)!.confirmAction),
      content: Text(
        S.of(context)!.areYouSureYouWantToContinue,
      ),
      actions: [
        const DialogCancelButton(),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            S.of(context)!.confirm,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(Label label) {
    Widget? trailingIcon;
    if (_initialValues.length > 1 &&
        _selection == null &&
        _initialValues.contains(label.id)) {
      trailingIcon = const Icon(Icons.remove);
    } else if (_selection?.label == label.id) {
      trailingIcon = const Icon(Icons.done);
    }
    return ListTile(
      title: Text(label.name),
      trailing: trailingIcon,
      onTap: () {
        if (_selection?.label == label.id) {
          setState(() {
            _selection = LabelSelection(null);
          });
        } else {
          setState(() {
            _selection = LabelSelection(label.id);
          });
        }
      },
    );
  }
}

class LabelSelection {
  final int? label;

  LabelSelection(this.label);
}
