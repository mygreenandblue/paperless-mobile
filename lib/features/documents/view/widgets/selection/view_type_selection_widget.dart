import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
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
    late final IconData icon;
    switch (viewType) {
      case ViewType.grid:
        icon = Icons.grid_view_rounded;
        break;
      case ViewType.list:
        icon = Icons.list;
        break;
      case ViewType.detailed:
        icon = Icons.article_outlined;
        break;
    }
    return PopupMenuButton<ViewType>(
      child: Icon(icon),
      itemBuilder: (context) => [
        _buildViewTypeOption(
          ViewType.list,
          'List',
          Icons.list,
        ),
        _buildViewTypeOption(
          ViewType.grid,
          'Grid',
          Icons.grid_view_rounded,
        ),
        _buildViewTypeOption(
          ViewType.detailed,
          'Detailed',
          Icons.article_outlined,
        ),
      ],
      onSelected: (next) {
        onChanged(next);
      },
    );
  }

  PopupMenuItem<ViewType> _buildViewTypeOption(
    ViewType type,
    String label,
    IconData icon,
  ) {
    return PopupMenuItem(
      value: type,
      child: ListTile(
        selected: type == viewType,
        trailing: type == viewType ? const Icon(Icons.done) : null,
        title: Text(label),
        leading: Icon(icon),
      ),
    );
  }
}
