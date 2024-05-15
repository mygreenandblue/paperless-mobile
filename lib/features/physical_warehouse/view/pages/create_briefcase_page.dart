// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';

import 'package:paperless_mobile/features/physical_warehouse/view/pages/form/physical_warehouse_form.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class SubmitButtonConfig<T extends Label> {
  final String? initialName;

  final T Function(Map<String, dynamic> json) fromJsonT;
  final List<Widget> additionalFields;
  final Future<T> Function(BuildContext context, T label) onSubmit;
  SubmitButtonConfig({
    this.initialName,
    required this.fromJsonT,
    required this.additionalFields,
    required this.onSubmit,
  });
}

class CreateBriefcasePage<T> extends StatelessWidget {
  final String action;
  final String? name;
  final String? initialShelf;
  final String? initialWarehouse;
  const CreateBriefcasePage({
    Key? key,
    required this.action,
    this.name,
    this.initialShelf,
    this.initialWarehouse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(action == 'edit'
              ? S.of(context)!.editBriefcase
              : S.of(context)!.addWarehouse),
        ),
        body: PhysicalWarehouseForm(
          autofocusNameField: true,
          type: 'briefcase',
          initialName: name,
          initialShelf: initialShelf,
          initialWarehouse: initialWarehouse,
          action: action,
        ),
      ),
    );
  }
}
