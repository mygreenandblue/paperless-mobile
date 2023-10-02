import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/config/hive/hive_extensions.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/features/document_upload/view/document_upload_preparation_page.dart';
import 'package:paperless_mobile/features/notifications/services/local_notification_service.dart';
import 'package:paperless_mobile/features/sharing/cubit/receive_share_cubit.dart';
import 'package:paperless_mobile/features/sharing/view/dialog/discard_shared_file_dialog.dart';
import 'package:paperless_mobile/features/tasks/cubit/task_status_cubit.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routes/typed/branches/scanner_route.dart';
import 'package:paperless_mobile/routes/typed/branches/upload_queue_route.dart';
import 'package:path/path.dart' as p;
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class UploadQueueShell extends StatefulWidget {
  final Widget child;
  const UploadQueueShell({super.key, required this.child});

  @override
  State<UploadQueueShell> createState() => _UploadQueueShellState();
}

class _UploadQueueShellState extends State<UploadQueueShell> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    ReceiveSharingIntent.getInitialMedia().then(_onReceiveSharedFiles);
    _subscription =
        ReceiveSharingIntent.getMediaStream().listen(_onReceiveSharedFiles);

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   context.read<ReceiveShareCubit>().loadFromConsumptionDirectory(
    //         userId: context.read<LocalUserAccount>().id,
    //       );
    //   final state = context.read<ReceiveShareCubit>().state;
    //   print("Current state is " + state.toString());
    //   final files = state.files;
    //   if (files.isNotEmpty) {
    //     showSnackBar(
    //       context,
    //       "You have ${files.length} shared files waiting to be uploaded.",
    //       action: SnackBarActionConfig(
    //         label: "Show me",
    //         onPressed: () {
    //           UploadQueueRoute().push(context);
    //         },
    //       ),
    //     );
    //     // showDialog(
    //     //   context: context,
    //     //   builder: (context) => AlertDialog(
    //     //     title: Text("Pending files"),
    //     //     content: Text(
    //     //       "You have ${files.length} files waiting to be uploaded.",
    //     //     ),
    //     //     actions: [
    //     //       TextButton(
    //     //         child: Text(S.of(context)!.gotIt),
    //     //         onPressed: () {
    //     //           Navigator.pop(context);
    //     //           UploadQueueRoute().push(context);
    //     //         },
    //     //       ),
    //     //     ],
    //     //   ),
    //     // );
    //   }
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<PendingTasksNotifier>().addListener(_onTasksChanged);
  }

  void _onTasksChanged() {
    final taskNotifier = context.read<PendingTasksNotifier>();
    for (var task in taskNotifier.value.values) {
      context.read<LocalNotificationService>().notifyTaskChanged(task);
    }
  }

  void _onReceiveSharedFiles(List<SharedMediaFile> sharedFiles) async {
    final files = sharedFiles.map((file) => File(file.path)).toList();

    if (files.isNotEmpty) {
      final userId = context.read<LocalUserAccount>().id;
      final notifier = context.read<ConsumptionChangeNotifier>();
      await notifier.addFiles(
        files: files,
        userId: userId,
      );
      final localFiles = notifier.pendingFiles;
      for (int i = 0; i < localFiles.length; i++) {
        final file = localFiles[i];
        await consumeLocalFile(
          context,
          file: file,
          userId: userId,
          exitAppAfterConsumed: i == localFiles.length - 1,
        );
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    context.read<PendingTasksNotifier>().removeListener(_onTasksChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

Future<void> consumeLocalFile(
  BuildContext context, {
  required File file,
  required String userId,
  bool exitAppAfterConsumed = false,
}) async {
  final consumptionNotifier = context.read<ConsumptionChangeNotifier>();
  final taskNotifier = context.read<PendingTasksNotifier>();
  final ioFile = File(file.path);
  // if (!await ioFile.exists()) {
  //   Fluttertoast.showToast(
  //     msg: S.of(context)!.couldNotAccessReceivedFile,
  //     toastLength: Toast.LENGTH_LONG,
  //   );
  // }

  final bytes = ioFile.readAsBytes();
  final shouldDirectlyUpload =
      Hive.globalSettingsBox.getValue()!.skipDocumentPreprarationOnUpload;
  if (shouldDirectlyUpload) {
    final taskId = await context.read<PaperlessDocumentsApi>().create(
          await bytes,
          filename: p.basename(file.path),
          title: p.basenameWithoutExtension(file.path),
        );
    consumptionNotifier.discardFile(file, userId: userId);
    if (taskId != null) {
      taskNotifier.listenToTaskChanges(taskId);
    }
  } else {
    final result = await DocumentUploadRoute(
          $extra: bytes,
          filename: p.basenameWithoutExtension(file.path),
          title: p.basenameWithoutExtension(file.path),
          fileExtension: p.extension(file.path),
        ).push<DocumentUploadResult>(context) ??
        DocumentUploadResult(false, null);

    if (result.success) {
      await Fluttertoast.showToast(
        msg: S.of(context)!.documentSuccessfullyUploadedProcessing,
      );
      await consumptionNotifier.discardFile(file, userId: userId);

      if (result.taskId != null) {
        taskNotifier.listenToTaskChanges(result.taskId!);
      }
      if (exitAppAfterConsumed) {
        SystemNavigator.pop();
      }
    } else {
      final shouldDiscard = await showDialog<bool>(
            context: context,
            builder: (context) => DiscardSharedFileDialog(bytes: bytes),
          ) ??
          false;
      if (shouldDiscard) {
        await context
            .read<ConsumptionChangeNotifier>()
            .discardFile(file, userId: userId);
      }
    }
  }
}
