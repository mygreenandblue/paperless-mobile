import 'package:flutter/material.dart';
import 'package:paperless_mobile/features/settings/model/view_type.dart';

/// Meant to be used with blocbuilder.
class ViewTypeSelectionWidget extends StatelessWidget {
  final ViewType viewType;
  final void Function(ViewType type) onChanged;

  const ViewTypeSelectionWidget({
    super.key,
    required this.viewType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final next = viewType.toggle();
    final icon = next == ViewType.grid ? Icons.grid_view_rounded : Icons.list;
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        onChanged(next);
      },
    );
  }
}
