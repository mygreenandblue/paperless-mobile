import 'package:flutter/material.dart';

class ExpansionCard extends StatelessWidget {
  final Widget title;
  final Widget content;

  final bool initiallyExpanded;

  const ExpansionCard({
    super.key,
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.all(16),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          expansionTileTheme: ExpansionTileThemeData(
            shape: Theme.of(context).cardTheme.shape,
            collapsedShape: Theme.of(context).cardTheme.shape,
          ),
          listTileTheme: ListTileThemeData(
            shape: Theme.of(context).cardTheme.shape,
          ),
        ),
        child: ExpansionTile(
          backgroundColor: ElevationOverlay.applySurfaceTint(
            colorScheme.surface,
            colorScheme.surfaceTint,
            4,
          ),
          initiallyExpanded: initiallyExpanded,
          collapsedBackgroundColor: ElevationOverlay.applySurfaceTint(
            colorScheme.surface,
            colorScheme.surfaceTint,
            4,
          ),
          title: title,
          children: [content],
        ),
      ),
    );
  }
}
