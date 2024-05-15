import 'package:flutter/material.dart';

class PhysicalWarehouseListItem extends StatelessWidget {
  final String name;
  final String? organization;
  final String? shelf;
  final String? warehouse;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          type == 'warehouse'
              ? Text('Organization: $organization')
              : const SizedBox(),
          type == 'briefcase' ? Text('Shelf: $shelf') : const SizedBox(),
          type == 'briefcase' || type == 'shelf'
              ? Text('Warehouse: $warehouse')
              : const SizedBox(),
        ],
      ),
      onTap: () {},
    );
  }
}
