import 'package:flutter/material.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class DialogCancelButton extends StatelessWidget {
  final void Function()? onTap;
  const DialogCancelButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(S.of(context)!.cancel),
      onPressed: onTap ?? () => Navigator.pop(context),
    );
  }
}
