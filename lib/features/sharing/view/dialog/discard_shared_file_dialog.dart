import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_confirm_button.dart';
import 'package:paperless_mobile/core/widgets/future_or_builder.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:transparent_image/transparent_image.dart';

class DiscardSharedFileDialog extends StatelessWidget {
  final FutureOr<Uint8List> bytes;
  const DiscardSharedFileDialog({
    super.key,
    required this.bytes,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: FutureOrBuilder<Uint8List>(
        future: bytes,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return LimitedBox(
            maxHeight: 200,
            maxWidth: 200,
            child: FadeInImage(
              fit: BoxFit.contain,
              placeholder: MemoryImage(kTransparentImage),
              image: MemoryImage(snapshot.data!),
            ),
          );
        },
      ),
      title: Text(S.of(context)!.discardFile),
      content: Text(
        "The shared file was not yet processed. Do you want to discrad the file?", //TODO: INTL
      ),
      actions: [
        DialogCancelButton(),
        DialogConfirmButton(
          label: S.of(context)!.discard,
          style: DialogConfirmButtonStyle.danger,
        ),
      ],
    );
  }
}
