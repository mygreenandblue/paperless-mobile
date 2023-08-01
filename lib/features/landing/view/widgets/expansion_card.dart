import 'package:flutter/material.dart';

class ExpansionCard extends StatelessWidget {
  final Widget title;
  final Widget content;

  const ExpansionCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Theme.of(context).colorScheme.surface,
          initiallyExpanded: true,
          title: title,
          children: [content],
        ),
      ),
    );
  }
}
