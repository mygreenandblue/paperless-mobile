import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:paperless_mobile/core/service/file_service.dart';
import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';

late Logger logger;

class MirroredFileOutput extends LogOutput {
  late final File file;
  final Completer _initCompleter = Completer();
  MirroredFileOutput();

  @override
  Future<void> init() async {
    final today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    final logDir = await FileService.logDirectory;
    file = File(p.join(logDir.path, '$today.log'));
    debugPrint("Logging files to ${file.path}.");
    _initCompleter.complete();
    try {
      final oldLogs = await logDir.list().whereType<File>().toList();
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
    for (var line in event.lines) {
      debugPrint(line);
      if (_initCompleter.isCompleted) {
        await file.writeAsString(
          "$line\n",
          mode: FileMode.append,
        );
      }
    }
  }
}

class SpringBootLikePrinter extends LogPrinter {
  SpringBootLikePrinter();
  static final _timestampFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");

  @override
  List<String> log(LogEvent event) {
    final level = _buildLeftAligned(event.level.name.toUpperCase(),
        Level.values.map((e) => e.name.length).max);
    String message = _stringifyMessage(event.message);
    final timestamp =
        _buildLeftAligned(_timestampFormat.format(event.time), 23);
    final traceRegex = RegExp(r"(.*)#(.*)\(\): (.*)");
    final match = traceRegex.firstMatch(message);
    if (match != null) {
      final className = match.group(1)!;
      final methodName = match.group(2)!;
      final remainingMessage = match.group(3)!;
      final formattedClassName = _buildRightAligned(className, 25);
      final formattedMethodName = _buildLeftAligned(methodName, 25);
      message = message.replaceFirst(traceRegex,
          "[$formattedClassName] - $formattedMethodName: $remainingMessage");
    } else {
      message = List.filled(55, " ").join("") + ": " + message;
    }
    return [
      '$timestamp\t$level --- $message',
      if (event.error != null) '\t\t${event.error}',
      if (event.stackTrace != null) '\t\t${event.stackTrace.toString()}',
    ];
  }

  String _buildLeftAligned(String message, int maxLength) {
    return message.padRight(maxLength, ' ');
  }

  String _buildRightAligned(String message, int maxLength) {
    return message.padLeft(maxLength, ' ');
  }

  String _stringifyMessage(dynamic message) {
    final finalMessage = message is Function ? message() : message;
    if (finalMessage is Map || finalMessage is Iterable) {
      var encoder = const JsonEncoder.withIndent(null);
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }
}
