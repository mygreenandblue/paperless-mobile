import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/unsaved_changes_warning_dialog.dart';

class PopWithUnsavedChanges extends StatelessWidget {
  final bool Function() hasChangesPredicate;
  final Widget child;

  const PopWithUnsavedChanges({
    super.key,
    required this.hasChangesPredicate,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (hasChangesPredicate()) {
          final shouldPop = await showDialog<bool>(
                context: context,
                builder: (context) => const UnsavedChangesWarningDialog(),
              ) ??
              false;
          return shouldPop;
        }
        return true;
      },
      child: child,
    );
  }
}
