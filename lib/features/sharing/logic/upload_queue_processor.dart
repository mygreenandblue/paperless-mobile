import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/global/constants.dart';
import 'package:paperless_mobile/core/translation/error_code_localization_mapper.dart';
import 'package:paperless_mobile/features/document_upload/view/document_upload_preparation_page.dart';
import 'package:paperless_mobile/features/sharing/model/share_intent_queue.dart';
import 'package:paperless_mobile/features/sharing/view/dialog/discard_shared_file_dialog.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routes/typed/branches/scanner_route.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:path/path.dart' as p;

class UploadQueueProcessor {
  final ShareIntentQueue queue;

  UploadQueueProcessor({required this.queue});

  bool _isFileTypeSupported(File file) {
    final isSupported =
        supportedFileExtensions.contains(p.extension(file.path));
    return isSupported;
  }

  void processIncomingFiles(
    BuildContext context, {
    required List<SharedMediaFile> sharedFiles,
  }) async {
    if (sharedFiles.isEmpty) {
      return;
    }
    Iterable<File> files = sharedFiles.map((file) => File(file.path));
    if (Platform.isIOS) {
      files = files
          .map((file) => File(file.path.replaceAll('file://', '')))
          .toList();
    }
    final supportedFiles = files.where(_isFileTypeSupported);
    final unsupportedFiles = files.whereNot(_isFileTypeSupported);
    debugPrint(
        "Received ${files.length} files, out of which ${supportedFiles.length} are supported.}");
    if (supportedFiles.isEmpty) {
      Fluttertoast.showToast(
        msg: translateError(
          context,
          ErrorCode.unsupportedFileFormat,
        ),
      );
      if (Platform.isAndroid) {
        // As stated in the docs, SystemNavigator.pop() is ignored on IOS to comply with HCI guidelines.
        await SystemNavigator.pop();
      }
      return;
    }
    if (unsupportedFiles.isNotEmpty) {
      //TODO: INTL
      Fluttertoast.showToast(
          msg:
              "${unsupportedFiles.length}/${files.length} files could not be processed.");
    }
    await ShareIntentQueue.instance.addAll(
      supportedFiles,
      userId: context.read<LocalUserAccount>().id,
    );
  }
}
