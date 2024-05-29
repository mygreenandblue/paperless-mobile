import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/pop_with_unsaved_changes.dart';
import 'package:paperless_mobile/features/labels/cubit/label_cubit.dart';
import 'package:paperless_mobile/features/physical_warehouse/view/impl/physical_warehouse_form.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class EditPhysicalWarehousePage<T extends WarehouseModel>
    extends StatelessWidget {
  final T warehouse;
  final T Function(Map<String, dynamic> json) fromJsonT;
  final String type;

  final String? labelButtonSubmit;
  final GlobalKey<FormBuilderState>? formKey;
  final bool canDelete;
  final WarehouseFilter initialFilter;

  const EditPhysicalWarehousePage(
      {super.key,
      required this.warehouse,
      required this.fromJsonT,
      required this.type,
      required this.canDelete,
      required this.initialFilter,
      this.labelButtonSubmit,
      required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LabelCubit(
        context.read<LabelRepository>(),
      ),
      child: EditPhysicalWarehouseForm(
        warehouse: warehouse,
        type: type,
        fromJsonT: fromJsonT,
        canDelete: canDelete,
        initialFilter: initialFilter,
        labelButtonSubmit: labelButtonSubmit,
        formKey: formKey,
      ),
    );
  }
}

class EditPhysicalWarehouseForm<T extends WarehouseModel>
    extends StatelessWidget {
  final T warehouse;
  final T Function(Map<String, dynamic> json) fromJsonT;
  final String type;

  final String? labelButtonSubmit;
  final GlobalKey<FormBuilderState>? formKey;
  final bool canDelete;

  final WarehouseFilter initialFilter;

  EditPhysicalWarehouseForm(
      {super.key,
      required this.warehouse,
      required this.fromJsonT,
      required this.type,
      required this.canDelete,
      required this.initialFilter,
      this.labelButtonSubmit,
      required this.formKey});

  @override
  Widget build(BuildContext context) {
    return PopWithUnsavedChanges(
      hasChangesPredicate: () {
        return formKey?.currentState?.isDirty ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context)!.edit),
        ),
        body: PhysicalWarehouseForm<T>(
          type: type,
          formKey: formKey,
          autofocusNameField: false,
          initialValue: warehouse,
          fromJsonT: fromJsonT,
          iconButtonSubmit: const Icon(Icons.save),
          labelButtonSubmit: Text(labelButtonSubmit ?? ''),
          initialFilter: initialFilter,
          action: 'edit',
        ),
      ),
    );
  }
}
