import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/database/hive/hive_config.dart';
import 'package:edocs_mobile/core/database/tables/local_user_account.dart';
import 'package:edocs_mobile/core/extensions/flutter_extensions.dart';
import 'package:edocs_mobile/features/document_details/cubit/document_details_cubit.dart';
import 'package:edocs_mobile/features/document_details/view/dialogs/select_file_type_dialog.dart';
import 'package:edocs_mobile/core/database/tables/global_settings.dart';
import 'package:edocs_mobile/features/settings/model/file_download_type.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

import 'package:edocs_mobile/helpers/message_helpers.dart';
import 'package:edocs_mobile/helpers/permission_helpers.dart';
import 'package:edocs_mobile/constants.dart';
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
      tooltip: S.of(context)!.downloadDocumentTooltip,
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
    try {
      final globalSettings =
          Hive.box<GlobalSettings>(HiveBoxes.globalSettings).getValue()!;
      bool original;

      switch (globalSettings.defaultDownloadType) {
        case FileDownloadType.original:
          original = true;
          break;
        case FileDownloadType.archived:
          original = false;
          break;
        case FileDownloadType.alwaysAsk:
          final isOriginal = await showDialog<bool>(
            context: context,
            builder: (context) => SelectFileTypeDialog(
              onRememberSelection: (downloadType) {
                globalSettings.defaultDownloadType = downloadType;
                globalSettings.save();
              },
            ),
          );
          if (isOriginal == null) {
            return;
          } else {
            original = isOriginal;
          }
          break;
      }

      // if (Platform.isAndroid && androidInfo!.version.sdkInt <= 29) {
      //   final isGranted = await askForPermission(Permission.storage);
      //   if (!isGranted) {
      //     return;
      //     //TODO: Ask user to grant permissions
      //   }
      // }

      setState(() => _isDownloadPending = true);
      final userId = context.read<LocalUserAccount>().id;
      await context.read<DocumentDetailsCubit>().downloadDocument(
            downloadOriginal: original,
            locale: globalSettings.preferredLocaleSubtag,
            userId: userId,
          );
      // showSnackBar(context, S.of(context)!.documentSuccessfullyDownloaded);
    } on EdocsApiException catch (error, stackTrace) {
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
