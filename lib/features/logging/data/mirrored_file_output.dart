import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:edocs_mobile/core/service/file_service.dart';
import 'package:path/path.dart' as p;
import 'package:synchronized/synchronized.dart';

typedef f = FileOutput;

class MirroredFileOutput extends LogOutput {
  var lock = Lock();
  MirroredFileOutput();

  late final File file;

  @override
  Future<void> init() async {
    final today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    final logDir = FileService.instance.logDirectory;
    file = File(p.join(logDir.path, '$today.log'));
    debugPrint("Logging files to ${file.path}.");
    try {
      final oldLogs = await FileService.instance.getAllFiles(logDir);
      if (oldLogs.length > 10) {
        oldLogs
            .sortedBy((file) => file.lastModifiedSync())
            .reversed
            .skip(10)
            .forEach((log) => log.delete());
      }
    } catch (e) {
      debugPrint("Failed to delete old logs...");
    }
  }

  @override
  void output(OutputEvent event) async {
    await lock.synchronized(() async {
      for (var line in event.lines) {
        debugPrint(line);
        await file.writeAsString(
          "$line${Platform.lineTerminator}",
          mode: FileMode.append,
        );
      }
    });
  }
}
