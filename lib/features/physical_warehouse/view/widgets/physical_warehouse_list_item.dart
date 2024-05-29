import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_confirm_button.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class PhysicalWarehouseListItem<T extends WarehouseModel>
    extends StatelessWidget {
  final T warehouseModel;
  final String name;
  final String? organization;
  final String? shelf;
  final String? warehouse;
  final void Function(T)? onEdit;
  final Future<void> Function(T warehouse) onDelete;
  final String type;

  const PhysicalWarehouseListItem({
    Key? key,
    required this.name,
    this.organization,
    this.shelf,
    this.warehouse,
    required this.onEdit,
    required this.onDelete,
    required this.type,
    required this.warehouseModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit != null ? () => onEdit!(warehouseModel) : null,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _onDelete(context),
          ),
        ],
      ),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          type == 'Warehouse'
              ? Text('Organization: $organization')
              : const SizedBox(),
          type == 'Boxcase' ? Text('Shelf: $shelf') : const SizedBox(),
          type == 'Boxcase' || type == 'Shelf'
              ? Text('Warehouse: $warehouse')
              : const SizedBox(),
        ],
      ),
      onTap: () {},
    );
  }

  void _onDelete(BuildContext context) async {
    if ((warehouseModel.documentCount ?? 0) >= 0) {
      await showDialog<bool>(
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
                onPressed: () {
                  try {
                    onDelete(warehouseModel);
                    Navigator.of(context).pop(true);
                  } on PaperlessApiException catch (error) {
                    showErrorMessage(context, error);
                  } catch (error, stackTrace) {
                    log("An error occurred!",
                        error: error, stackTrace: stackTrace);
                  }
                }),
          ],
        ),
      );
    }
  }
}
