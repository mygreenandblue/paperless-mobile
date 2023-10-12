import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:paperless_mobile/core/logging/models/parsed_log_message.dart';
import 'package:paperless_mobile/core/service/file_service.dart';
import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';
part 'app_logs_state.dart';

final _fileNameFormat = DateFormat("yyyy-MM-dd");

class AppLogsCubit extends Cubit<AppLogsState> {
  StreamSubscription? _fileChangesSubscription;
  AppLogsCubit(DateTime date) : super(AppLogsStateInitial(date: date));

  Future<void> loadLogs(DateTime date) async {
    if (date == state.date) {
      return;
    }
    _fileChangesSubscription?.cancel();
    emit(AppLogsStateLoading(date: date));
    final logDir = FileService.instance.logDirectory;
    final availableLogs = (await logDir
            .list()
            .whereType<File>()
            .where((event) => event.path.endsWith('.log'))
            .map((e) =>
                _fileNameFormat.parse(p.basenameWithoutExtension(e.path)))
            .toList())
        .sorted();
    final logFile = _getLogfile(date);
    if (!await logFile.exists()) {
      emit(AppLogsStateLoaded(
        date: date,
        logs: [],
        availableLogs: availableLogs,
      ));
    }
    try {
      final logs = await logFile.readAsLines();
      final parsedLogs =
          ParsedLogMessage.parse(logs.skip(2000).toList()).reversed.toList();
      _fileChangesSubscription = logFile.watch().listen((event) async {
        if (!isClosed) {
          final logs = await logFile.readAsLines();
          emit(AppLogsStateLoaded(
            date: date,
            logs: parsedLogs,
            availableLogs: availableLogs,
          ));
        }
      });
      emit(AppLogsStateLoaded(
        date: date,
        logs: parsedLogs,
        availableLogs: availableLogs,
      ));
    } catch (e) {
      emit(AppLogsStateError(
        error: e,
        date: date,
      ));
    }
  }

  Future<void> clearLogs(DateTime date) async {
    final logFile = _getLogfile(date);
    await logFile.writeAsString('');
    await loadLogs(date);
  }

  Future<void> copyToClipboard(DateTime date) async {
    final file = _getLogfile(date);
    if (!await file.exists()) {
      return;
    }
    final content = await file.readAsString();
    Clipboard.setData(ClipboardData(text: content));
  }

  Future<void> saveLogs(DateTime date, String locale) async {
    var formattedDate = _fileNameFormat.format(date);
    final filename = 'paperless_mobile_logs_$formattedDate.log';
    final parentDir = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "Save log from ${DateFormat.yMd(locale).format(date)}",
      initialDirectory: Platform.isAndroid
          ? FileService.instance.downloadsDirectory.path
          : null,
    );
    final logFile = _getLogfile(date);
    if (parentDir != null) {
      await logFile.copy(p.join(parentDir, filename));
    }
  }

  File _getLogfile(DateTime date) {
    return File(p.join(FileService.instance.logDirectory.path,
        '${_fileNameFormat.format(date)}.log'));
  }

  @override
  Future<void> close() {
    _fileChangesSubscription?.cancel();
    return super.close();
  }
}
