import 'dart:io';

import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/service/file_service.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/generated/l10n.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/helpers/permission_helpers.dart';
import 'package:paperless_mobile/constants.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentDownloadButton extends StatefulWidget {
  final DocumentModel? document;
  final bool enabled;
  const DocumentDownloadButton({
    super.key,
    required this.document,
    this.enabled = true,
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
    // if (!Platform.isAndroid) {
    //   showSnackBar(
    //       context, "This feature is currently only supported on Android!");
    //   return;
    // }
    if (Platform.isAndroid && androidInfo!.version.sdkInt! < 30) {
      final isGranted = await askForPermission(Permission.storage);
      if (!isGranted) {
        return;
      }
    }
    setState(() => _isDownloadPending = true);
    final service = context.read<PaperlessDocumentsApi>();
    try {
      final bytes = await service.download(document);
      final meta = await service.getMetaData(document);
      final Directory dir = await FileService.downloadsDirectory;
      String filePath = "${dir.path}/${meta.mediaFilename}";
      final createdFile = File(filePath);
      createdFile.createSync(recursive: true);
      createdFile.writeAsBytesSync(bytes);
      showSnackBar(context, S.of(context).documentDownloadSuccessMessage);
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
