import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_confirm_button.dart';
import 'package:paperless_mobile/features/edit_label/cubit/edit_label_cubit.dart';
import 'package:paperless_mobile/features/edit_label/view/label_form.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

import 'package:paperless_mobile/helpers/message_helpers.dart';

class EditLabelPage<T extends Label> extends StatelessWidget {
  final T label;
  final T Function(Map<String, dynamic> json) fromJsonT;
  final List<Widget> additionalFields;
  final Future<T> Function(BuildContext context, T label) onSubmit;
  final Future<void> Function(BuildContext context, T label) onDelete;

  const EditLabelPage({
    super.key,
    required this.label,
    required this.fromJsonT,
    this.additionalFields = const [],
    required this.onSubmit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditLabelCubit(
        context.read<LabelRepository>(),
      ),
      child: EditLabelForm(
        label: label,
        additionalFields: additionalFields,
        fromJsonT: fromJsonT,
        onSubmit: onSubmit,
        onDelete: onDelete,
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

  const EditLabelForm({
    super.key,
    required this.label,
    required this.fromJsonT,
    required this.additionalFields,
    required this.onSubmit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.edit),
        actions: [
          IconButton(
            onPressed: () => _onDelete(context),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: LabelForm<T>(
        autofocusNameField: false,
        initialValue: label,
        fromJsonT: fromJsonT,
        submitButtonConfig: SubmitButtonConfig<T>(
          icon: const Icon(Icons.save),
          label: Text(S.of(context)!.saveChanges),
          onSubmit: (label) => onSubmit(context, label),
        ),
        additionalFields: additionalFields,
      ),
    );
  }

  void _onDelete(BuildContext context) async {
    if ((label.documentCount ?? 0) > 0) {
      final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(S.of(context)!.confirmDeletion),
              content: Text(
                S.of(context)!.deleteLabelWarningText,
              ),
              actions: [
                const DialogCancelButton(),
                DialogConfirmButton(
                  label: S.of(context)!.delete,
                  style: DialogConfirmButtonStyle.danger,
                ),
              ],
            ),
          ) ??
          false;
      if (shouldDelete) {
        try {
          onDelete(context, label);
        } on PaperlessServerException catch (error) {
          showErrorMessage(context, error);
        } catch (error, stackTrace) {
          log("An error occurred!", error: error, stackTrace: stackTrace);
        }
        Navigator.pop(context);
      }
    } else {
      onDelete(context, label);
      Navigator.pop(context);
    }
  }
}
