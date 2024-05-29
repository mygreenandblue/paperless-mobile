import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/physical_warehouse/view/impl/physical_warehouse_form.dart';

class AddPhysicalWarehousePage<T extends WarehouseModel>
    extends StatelessWidget {
  final String? initialName;
  final WarehouseFilter initialFilter;
  final Widget pageTitle;
  final T Function(Map<String, dynamic> json) fromJsonT;
  final String type;

  final GlobalKey<FormBuilderState>? formKey;
  final String? labelButtonSubmit;

  const AddPhysicalWarehousePage({
    super.key,
    this.initialName,
    required this.pageTitle,
    required this.fromJsonT,
    required this.type,
    required this.initialFilter,
    this.formKey,
    this.labelButtonSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return AddPhysicalWarehouseFormWidget(
      initialFilter: initialFilter,
      pageTitle: pageTitle,
      warehouse: initialName != null ? fromJsonT({'name': initialName}) : null,
      fromJsonT: fromJsonT,
      type: type,
      formKey: formKey,
      labelButtonSubmit: labelButtonSubmit,
    );
  }
}

class AddPhysicalWarehouseFormWidget<T extends WarehouseModel>
    extends StatelessWidget {
  final T? warehouse;
  final T Function(Map<String, dynamic> json) fromJsonT;
  final WarehouseFilter initialFilter;

  final String type;
  final String? labelButtonSubmit;
  final Widget pageTitle;
  final GlobalKey<FormBuilderState>? formKey;
  const AddPhysicalWarehouseFormWidget({
    super.key,
    this.warehouse,
    required this.fromJsonT,
    required this.pageTitle,
    required this.type,
    required this.initialFilter,
    this.labelButtonSubmit,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: pageTitle,
      ),
      body: PhysicalWarehouseForm<T>(
        autofocusNameField: true,
        initialValue: warehouse,
        fromJsonT: fromJsonT,
        iconButtonSubmit: const Icon(Icons.add),
        labelButtonSubmit: Text(labelButtonSubmit ?? ''),
        type: type,
        initialFilter: initialFilter,
        formKey: formKey,
        action: 'create',
      ),
    );
  }
}
