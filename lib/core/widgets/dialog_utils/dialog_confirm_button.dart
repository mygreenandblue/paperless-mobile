import 'package:flutter/material.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

enum DialogConfirmButtonStyle {
  normal,
  danger;
}

class DialogConfirmButton<T> extends StatelessWidget {
  final DialogConfirmButtonStyle style;
  final String? label;
  final double? opacity;
  final bool enable;

  /// The value [Navigator.pop] will be called with. If [onPressed] is
  /// specified, this value will be ignored.
  final T? returnValue;

  /// Function called when the button is pressed. Takes precedence over [returnValue].
  final void Function()? onPressed;
  const DialogConfirmButton({
    super.key,
    this.style = DialogConfirmButtonStyle.normal,
    this.label,
    this.returnValue,
    this.onPressed,
    this.opacity,
    this.enable = true,
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
        Theme.of(context)
            .colorScheme
            .errorContainer
            .withOpacity(opacity ?? 1.0),
      ),
      foregroundColor: MaterialStatePropertyAll(
        Theme.of(context)
            .colorScheme
            .onErrorContainer
            .withOpacity(opacity ?? 1.0),
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

    final effectiveOnPressed =
        onPressed ?? () => Navigator.of(context).pop(returnValue ?? true);
    return ElevatedButton(
      style: _style,
      onPressed: enable ? effectiveOnPressed : null,
      child: Text(label ?? S.of(context)!.confirm),
    );
  }
}
