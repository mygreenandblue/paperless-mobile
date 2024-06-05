// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';

import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/features/edit_label/view/label_form.dart';
import 'package:paperless_mobile/features/labels/cubit/label_cubit.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class AddLabelPage<T extends Label> extends StatelessWidget {
  final String? initialName;
  final Widget pageTitle;
  final T Function(Map<String, dynamic> json) fromJsonT;
  final List<Widget> additionalFields;
  final Future<T> Function(BuildContext context, T label) onSubmit;
  final String? initialType;
  final String? initialShelf;
  final String? initialWarehouse;
  final Function(String?)? onChangedShelf;
  final Function(String?)? onChangedWarehouse;
  final int? parentId;

  const AddLabelPage({
    Key? key,
    this.initialName,
    required this.pageTitle,
    required this.fromJsonT,
    this.additionalFields = const [],
    required this.onSubmit,
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
      child: AddLabelFormWidget(
        pageTitle: pageTitle,
        label: initialName != null ? fromJsonT({'name': initialName}) : null,
        additionalFields: additionalFields,
        fromJsonT: fromJsonT,
        onSubmit: onSubmit,
        initialType: initialType,
        initialShelf: initialShelf,
        initialWarehouse: initialWarehouse,
        onChangedShelf: onChangedShelf,
        onChangedWarehouse: onChangedWarehouse,
        parentId: parentId,
      ),
    );
  }
}

class AddLabelFormWidget<T extends Label> extends StatelessWidget {
  final T? label;
  final T Function(Map<String, dynamic> json) fromJsonT;
  final List<Widget> additionalFields;
  final Future<T> Function(BuildContext context, T label) onSubmit;
  final String? initialType;
  final Widget pageTitle;

  final String? initialShelf;
  final String? initialWarehouse;
  final Function(String?)? onChangedShelf;
  final Function(String?)? onChangedWarehouse;
  final int? parentId;
  const AddLabelFormWidget({
    Key? key,
    this.label,
    required this.fromJsonT,
    required this.additionalFields,
    required this.onSubmit,
    this.initialType,
    required this.pageTitle,
    this.initialShelf,
    this.initialWarehouse,
    this.onChangedShelf,
    this.onChangedWarehouse,
    this.parentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: pageTitle,
      ),
      body: LabelForm<T>(
        autofocusNameField: true,
        initialValue: label,
        fromJsonT: fromJsonT,
        submitButtonConfig: SubmitButtonConfig<T>(
          icon: const Icon(Icons.add),
          label: Text(S.of(context)!.create),
          onSubmit: (label) => onSubmit(context, label),
        ),
        additionalFields: additionalFields,
        type: initialType,
        onChangedShelf: onChangedShelf,
        onChangedWarehouse: onChangedWarehouse,
        parentId: parentId,
      ),
    );
  }
}
