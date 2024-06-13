// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_api/edocs_api.dart';

import 'package:edocs_mobile/core/repository/label_repository.dart';
import 'package:edocs_mobile/features/edit_label/view/label_form.dart';
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

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
  final int? parentFolder;

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
    this.parentFolder,
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
        parentFolder: parentFolder,
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
  final int? parentFolder;
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
    this.parentFolder,
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
        parentFolder: parentFolder,
      ),
    );
  }
}
