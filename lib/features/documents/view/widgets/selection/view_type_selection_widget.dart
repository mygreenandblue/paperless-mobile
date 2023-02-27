import 'package:flutter/material.dart';
import 'package:paperless_mobile/features/settings/model/view_type.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

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
      position: PopupMenuPosition.under,
      initialValue: viewType,
      icon: Icon(icon),
      itemBuilder: (context) => [
        _buildViewTypeOption(
          context,
          type: ViewType.list,
          label: S.of(context)!.list,
          icon: Icons.list,
        ),
        _buildViewTypeOption(
          context,
          type: ViewType.grid,
          label: S.of(context)!.grid,
          icon: Icons.grid_view_rounded,
        ),
        _buildViewTypeOption(
          context,
          type: ViewType.detailed,
          label: S.of(context)!.detailed,
          icon: Icons.article_outlined,
        ),
      ],
      onSelected: (next) {
        onChanged(next);
      },
    );
  }

  PopupMenuItem<ViewType> _buildViewTypeOption(
    BuildContext context, {
    required ViewType type,
    required String label,
    required IconData icon,
  }) {
    final selected = type == viewType;
    return PopupMenuItem(
      value: type,
      child: ListTile(
        selected: selected,
        trailing: selected ? const Icon(Icons.done) : null,
        title: Text(label),
        iconColor: Theme.of(context).colorScheme.onSurface,
        textColor: Theme.of(context).colorScheme.onSurface,
        leading: Icon(icon),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
