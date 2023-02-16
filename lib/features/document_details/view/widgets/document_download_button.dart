import 'dart:io';

import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/service/file_service.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/settings/view/widgets/radio_settings_dialog.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/helpers/permission_helpers.dart';
import 'package:paperless_mobile/constants.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentDownloadButton extends StatefulWidget {
  final DocumentModel? document;
  final bool enabled;
  final Future<DocumentMetaData> metaData;
  const DocumentDownloadButton({
    super.key,
    required this.document,
    this.enabled = true,
    required this.metaData,
  });

  @override
  State<DocumentDownloadButton> createState() => _DocumentDownloadButtonState();
}

class _DocumentDownloadButtonState extends State<DocumentDownloadButton> {
  bool _isDownloadPending = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _isDownloadPending
          ? const SizedBox(
              child: CircularProgressIndicator(),
              height: 16,
              width: 16,
            )
          : const Icon(Icons.download),
      onPressed: widget.document != null && widget.enabled
          ? () => _onDownload(widget.document!)
          : null,
    ).paddedOnly(right: 4);
  }

  Future<void> _onDownload(DocumentModel document) async {
    final api = context.read<PaperlessDocumentsApi>();
    final meta = await widget.metaData;
    try {
      final downloadOriginal = await showDialog<bool>(
        context: context,
        builder: (context) => RadioSettingsDialog(
          titleText: S.of(context)!.chooseFiletype,
          options: [
            RadioOption(
                value: true,
                label: S.of(context)!.original +
                    " (${meta.originalMimeType.split("/").last})"),
            RadioOption(
              value: false,
              label: S.of(context)!.archivedPdf,
            ),
          ],
          initialValue: false,
        ),
      );
      if (downloadOriginal == null) {
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
      final bytes = await api.download(
        document,
        original: downloadOriginal,
      );
      final Directory dir = await FileService.downloadsDirectory;
      final fileExtension =
          downloadOriginal ? meta.mediaFilename.split(".").last : 'pdf';
      String filePath = "${dir.path}/${meta.mediaFilename}".split(".").first;
      filePath += ".$fileExtension";
      final createdFile = File(filePath);
      createdFile.createSync(recursive: true);
      createdFile.writeAsBytesSync(bytes);
      debugPrint("Downloaded file to $filePath");
      showSnackBar(context, S.of(context)!.documentSuccessfullyDownloaded);
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
