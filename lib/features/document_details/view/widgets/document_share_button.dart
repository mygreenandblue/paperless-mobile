import 'dart:io';

import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/constants.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_details/cubit/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/dialogs/select_file_type_dialog.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/helpers/permission_helpers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class DocumentShareButton extends StatefulWidget {
  final DocumentModel? document;
  final bool enabled;
  const DocumentShareButton({
    super.key,
    required this.document,
    this.enabled = true,
  });

  @override
  State<DocumentShareButton> createState() => _DocumentShareButtonState();
}

class _DocumentShareButtonState extends State<DocumentShareButton> {
  bool _isDownloadPending = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: S.of(context)!.shareTooltip,
      icon: _isDownloadPending
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(),
            )
          : const Icon(Icons.share),
      onPressed: widget.document != null && widget.enabled
          ? () => _onShare(widget.document!)
          : null,
    ).paddedOnly(right: 4);
  }

  Future<void> _onShare(DocumentModel document) async {
    try {
      final shareOriginal = await showDialog<bool>(
        context: context,
        builder: (context) => const SelectFileTypeDialog(),
      );
      if (shareOriginal == null) {
        // Download was cancelled
        return;
      }
      if (Platform.isAndroid && androidInfo!.version.sdkInt! < 30) {
        final isGranted = await askForPermission(Permission.storage);
        if (!isGranted) {
          return;
        }
      }
      setState(() => _isDownloadPending = true);
      await context
          .read<DocumentDetailsCubit>()
          .shareDocument(shareOriginal: shareOriginal);
    } on PaperlessServerException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    } catch (error) {
      showGenericError(context, error);
    } finally {
      if (mounted) {
        setState(() => _isDownloadPending = false);
      }
    }
  }
}
