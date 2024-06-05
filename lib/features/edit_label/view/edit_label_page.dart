// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_api/paperless_api.dart';

import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_confirm_button.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/pop_with_unsaved_changes.dart';
import 'package:paperless_mobile/features/edit_label/view/label_form.dart';
import 'package:paperless_mobile/features/labels/cubit/label_cubit.dart';
import 'package:paperless_mobile/features/labels/view/widgets/countdown.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class EditLabelPage<T extends Label> extends StatelessWidget {
  final T label;
  final T Function(Map<String, dynamic> json) fromJsonT;
  final List<Widget> additionalFields;
  final Future<T> Function(BuildContext context, T label) onSubmit;
  final Future<void> Function(BuildContext context, T label) onDelete;
  final bool canDelete;
  final String? type;
  final String? initialType;
  final int? initialShelf;
  final int? initialWarehouse;
  final Function(String?)? onChangedShelf;
  final Function(String?)? onChangedWarehouse;
  final int? parentId;

  const EditLabelPage({
    Key? key,
    required this.label,
    required this.fromJsonT,
    this.additionalFields = const [],
    required this.onSubmit,
    required this.onDelete,
    required this.canDelete,
    this.type,
    this.initialType,
    this.initialShelf,
    this.initialWarehouse,
    this.onChangedShelf,
    this.onChangedWarehouse,
    this.parentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LabelCubit(
        context.read<LabelRepository>(),
      ),
      child: EditLabelForm(
        label: label,
        additionalFields: additionalFields,
        fromJsonT: fromJsonT,
        onSubmit: onSubmit,
        onDelete: onDelete,
        canDelete: canDelete,
        type: type,
        initialShelf: initialShelf,
        initialWarehouse: initialWarehouse,
        onChangedShelf: onChangedShelf,
        onChangedWarehouse: onChangedWarehouse,
        parentId: parentId,
      ),
    );
  }
}

class EditLabelForm<T extends Label> extends StatelessWidget {
  final T label;
  final T Function(Map<String, dynamic> json) fromJsonT;
  final List<Widget> additionalFields;
  final Future<T> Function(BuildContext context, T label) onSubmit;
  final Future<void> Function(BuildContext context, T label) onDelete;
  final bool canDelete;
  final _formKey = GlobalKey<FormBuilderState>();
  final String? type;
  final String? initialType;
  final int? initialShelf;
  final int? initialWarehouse;
  final Function(String?)? onChangedShelf;
  final Function(String?)? onChangedWarehouse;
  final int? parentId;

  EditLabelForm({
    Key? key,
    required this.label,
    required this.fromJsonT,
    required this.additionalFields,
    required this.onSubmit,
    required this.onDelete,
    required this.canDelete,
    this.type,
    this.initialType,
    this.initialShelf,
    this.initialWarehouse,
    this.onChangedShelf,
    this.onChangedWarehouse,
    this.parentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopWithUnsavedChanges(
      hasChangesPredicate: () {
        return _formKey.currentState?.isDirty ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context)!.edit),
          actions: [
            IconButton(
              onPressed: canDelete ? () => _onDelete(context) : null,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: LabelForm<T>(
          formKey: _formKey,
          autofocusNameField: false,
          initialValue: label,
          fromJsonT: fromJsonT,
          submitButtonConfig: SubmitButtonConfig<T>(
            icon: const Icon(Icons.save),
            label: Text(S.of(context)!.saveChanges),
            onSubmit: (label) => onSubmit(context, label),
          ),
          additionalFields: additionalFields,
          action: 'edit',
          type: type,
          initialWarehouse: initialWarehouse,
          onChangedShelf: onChangedShelf,
          onChangedWarehouse: onChangedWarehouse,
          parentId: parentId,
        ),
      ),
    );
  }

  void _onDelete(BuildContext context) async {
    bool countdownComplete = false;
    if ((label.documentCount ?? 0) > 0) {
      final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Text(S.of(context)!.confirmDeletion),
                content: Text(
                  S.of(context)!.deleteLabelWarningText,
                ),
                actions: [
                  const DialogCancelButton(),
                  DialogConfirmButton(
                    enable: countdownComplete ? true : false,
                    label: S.of(context)!.delete,
                    style: DialogConfirmButtonStyle.danger,
                    opacity: countdownComplete ? 1 : 0.2,
                  ),
                  if (countdownComplete == false)
                    CountdownWidget(
                      start: 3,
                      onCountdownComplete: () {
                        setState(() {
                          countdownComplete = true;
                        });
                      },
                    )
                ],
              );
            }),
          ) ??
          false;
      if (shouldDelete) {
        try {
          onDelete(context, label);
        } on PaperlessApiException catch (error) {
          showErrorMessage(context, error);
        } catch (error, stackTrace) {
          log("An error occurred!", error: error, stackTrace: stackTrace);
        }
        showSnackBar(
          context,
          S.of(context)!.documentSuccessfullyUploadedProcessing,
        );

        context.pop();
      }
    } else {
      onDelete(context, label);
      showSnackBar(
        context,
        S.of(context)!.documentSuccessfullyUploadedProcessing,
      );

      context.pop();
    }
  }
}
