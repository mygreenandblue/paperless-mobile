// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';

import 'package:paperless_mobile/features/physical_warehouse/view/pages/form/physical_warehouse_form.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class CreateWarehousePage<T> extends StatelessWidget {
  final String action;
  final String? name;
  const CreateWarehousePage({super.key, required this.action, this.name});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(action == 'edit'
              ? S.of(context)!.editWarehouse
              : S.of(context)!.addWarehouse),
        ),
        body: PhysicalWarehouseForm(
          autofocusNameField: true,
          type: 'warehouse',
          initialName: name,
          action: action,
        ),
      ),
    );
  }
}
