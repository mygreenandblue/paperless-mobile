import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

enum DialogConfirmButtonStyle {
  normal,
  danger;
}

class DialogConfirmButton<T> extends StatelessWidget {
  final DialogConfirmButtonStyle style;
  final String? label;
  final T? returnValue;
  const DialogConfirmButton({
    super.key,
    this.style = DialogConfirmButtonStyle.normal,
    this.label,
    this.returnValue,
  });

  @override
  Widget build(BuildContext context) {
    final _normalStyle = ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(
        Theme.of(context).colorScheme.primaryContainer,
      ),
      foregroundColor: MaterialStatePropertyAll(
        Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
    final _dangerStyle = ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(
        Theme.of(context).colorScheme.errorContainer,
      ),
      foregroundColor: MaterialStatePropertyAll(
        Theme.of(context).colorScheme.onErrorContainer,
      ),
    );

    late final ButtonStyle _style;
    switch (style) {
      case DialogConfirmButtonStyle.normal:
        _style = _normalStyle;
        break;
      case DialogConfirmButtonStyle.danger:
        _style = _dangerStyle;
        break;
    }
    return ElevatedButton(
      child: Text(label ?? S.of(context)!.confirm),
      style: _style,
      onPressed: () => Navigator.of(context).pop(returnValue ?? true),
    );
  }
}
