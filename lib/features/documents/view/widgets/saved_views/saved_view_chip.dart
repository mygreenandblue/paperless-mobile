import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paperless_api/paperless_api.dart';

class SavedViewChip extends StatelessWidget {
  final SavedView view;
  final void Function(SavedView view) onViewSelected;
  final void Function(SavedView vie) onUpdateView;
  final bool selected;
  final bool hasChanged;

  const SavedViewChip({
    super.key,
    required this.view,
    required this.onViewSelected,
    required this.selected,
    required this.hasChanged,
    required this.onUpdateView,
  });

  @override
  Widget build(BuildContext context) {
    return Badge(
      smallSize: 12,
      alignment: const AlignmentDirectional(1.1, -1.2),
      backgroundColor: Colors.red,
      isLabelVisible: hasChanged,
      child: FilterChip(
        avatar: Icon(
          Icons.saved_search,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        showCheckmark: false,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        selected: selected,
        label: Text(view.name),
        onSelected: (_) {
          onViewSelected(view);
        },
      ),
    );
  }
}
