import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:paperless_mobile/core/service/file_service.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:path/path.dart' as p;
import 'package:rxdart/subjects.dart';

final _fileNameFormat = DateFormat("yyyy-MM-dd");

class AppLogsPage extends StatefulWidget {
  const AppLogsPage({super.key});

  @override
  State<AppLogsPage> createState() => _AppLogsPageState();
}

class _AppLogsPageState extends State<AppLogsPage> {
  final _fileContentStream = BehaviorSubject();
  final ScrollController _scrollController = ScrollController();

  StreamSubscription? _fileChangesSubscription;

  late DateTime _date;
  File? file;
  bool autoScroll = true;
  List<DateTime>? _availableLogs;

  Future<void> _initFile() async {
    final logDir = await FileService.logDirectory;
    // logDir.listSync().whereType<File>().forEach((element) {
    //   element.deleteSync();
    // });
    if (logDir.listSync().isEmpty) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final filename = _fileNameFormat.format(_date);
      setState(() {
        file = File(p.join(logDir.path, '$filename.log'));
      });
      _scrollController.addListener(_initialScrollListener);
      _updateFileContent();
      _fileChangesSubscription?.cancel();
      _fileChangesSubscription = file!.watch().listen((event) async {
        await _updateFileContent();
      });
    });
  }

  void _initialScrollListener() {
    if (_scrollController.positions.isNotEmpty) {
      _scrollController.animateTo(
        0,
        duration: 500.milliseconds,
        curve: Curves.easeIn,
      );
      _scrollController.removeListener(_initialScrollListener);
    }
  }

  @override
  void initState() {
    super.initState();
    _date = DateTime.now().copyWith(
      minute: 0,
      hour: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
    _initFile();
    () async {
      final logDir = await FileService.logDirectory;
      final files = logDir.listSync(followLinks: false).whereType<File>();
      final fileNames = files.map((e) => p.basenameWithoutExtension(e.path));
      final dates =
          fileNames.map((filename) => _fileNameFormat.parseStrict(filename));
      _availableLogs = dates.toList();
    }();
  }

  @override
  void dispose() {
    _fileChangesSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Logs"),
            SizedBox(width: 16),
            DropdownButton<DateTime>(
              
              value: _date,
              items: [
                for (var date in _availableLogs ?? [])
                  DropdownMenuItem(
                    child: Text(DateFormat.yMMMd(locale).format(date)),
                    value: date,
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _date = value;
                  });
                  _initFile();
                }
              },
            ),
          ],
        ),
        actions: file != null
            ? [
                IconButton(
                  tooltip: "Save log file to selected directory",
                  onPressed: () => _saveFile(locale),
                  icon: const Icon(Icons.download),
                ),
                IconButton(
                  tooltip: "Copy logs to clipboard",
                  onPressed: _copyToClipboard,
                  icon: const Icon(Icons.copy),
                ).padded(),
              ]
            : null,
      ),
      body: Builder(
        builder: (context) {
          if (_availableLogs == null) {
            return Center(
              child: Text("No logs available."),
            );
          }
          return StreamBuilder(
            stream: _fileContentStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || file == null) {
                return const Center(
                  child: Text(
                    "Initializing logs...",
                  ),
                );
              }
              final messages = _transformLog(snapshot.data!).reversed.toList();
              return ColoredBox(
                color: theme.colorScheme.background,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Center(
                              child: Text(
                                "End of logs.",
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ).padded(24);
                          }
                          final logMessage = messages[index - 1];
                          final altColor = CupertinoDynamicColor.withBrightness(
                            color: Colors.grey.shade200,
                            darkColor: Colors.grey.shade800,
                          ).resolveFrom(context);
                          return _LogMessageWidget(
                            message: logMessage,
                            backgroundColor: (index % 2 == 0)
                                ? theme.colorScheme.background
                                : altColor,
                          );
                        },
                        itemCount: messages.length + 1,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _saveFile(String locale) async {
    assert(file != null);
    var formattedDate = _fileNameFormat.format(_date);
    final filename = 'paperless_mobile_logs_$formattedDate.log';
    final parentDir = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "Save log from ${DateFormat.yMd(locale).format(_date)}",
      initialDirectory:
          Platform.isAndroid ? "/storage/emulated/0/Download/" : null,
    );
    if (parentDir != null) {
      await file!.copy(p.join(parentDir, filename));
    }
  }

  Future<void> _copyToClipboard() async {
    assert(file != null);
    final content = await file!.readAsString();
    await Clipboard.setData(ClipboardData(text: content));
  }

  List<_LogMessage> _transformLog(String log) {
    List<_LogMessage> messages = [];
    List<String> currentCoherentLines = [];
    final lines = log.split("\n");
    for (var line in lines) {
      final isMatch = _LogMessage.hasMatch(line);
      if (currentCoherentLines.isNotEmpty && isMatch) {
        messages.add(_LogMessage(message: currentCoherentLines.join("\n")));
        currentCoherentLines.clear();
        messages.add(_LogMessage.fromMessage(line));
      }
      if (_LogMessage.hasMatch(line)) {
        messages.add(_LogMessage.fromMessage(line));
      } else {
        currentCoherentLines.add(line);
      }
    }

    return messages;
  }

  Future<void> _updateFileContent() async {
    final content = await file!.readAsString();
    _fileContentStream.add(content);
    Future.delayed(400.milliseconds, () {
      _scrollController.animateTo(
        0,
        duration: 500.milliseconds,
        curve: Curves.easeIn,
      );
    });
  }
}

class _LogMessage {
  static final RegExp pattern = RegExp(
    r'(?<timestamp>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3})\s*(?<level>[A-Z]*)'
    r'\s+---\s*(?:\[\s*(?<className>.*)\]\s*-\s*(?<methodName>.*)\s*)?:\s*(?<message>.+)',
  );
  final Level? level;
  final String message;
  final String? className;
  final String? methodName;
  final DateTime? timestamp;

  bool get isFormatted => level != null;
  const _LogMessage({
    this.level,
    required this.message,
    this.className,
    this.methodName,
    this.timestamp,
  });

  static bool hasMatch(String message) => pattern.hasMatch(message);

  factory _LogMessage.fromMessage(String message) {
    final match = pattern.firstMatch(message);
    if (match == null) {
      return _LogMessage(message: message);
    }
    return _LogMessage(
      level: Level.values.byName(match.namedGroup('level')!.toLowerCase()),
      message: match.namedGroup('message')!,
      className: match.namedGroup('className'),
      methodName: match.namedGroup('methodName'),
      timestamp: DateTime.tryParse(match.namedGroup('timestamp') ?? ''),
    );
  }
}

class _LogMessageWidget extends StatelessWidget {
  final _LogMessage message;
  final Color backgroundColor;
  const _LogMessageWidget({
    required this.message,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    if (!message.isFormatted) {
      return Text(
        message.message,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 5,
              color: c.onBackground.withOpacity(0.7),
            ),
      );
    }
    final color = switch (message.level) {
      Level.trace => c.onBackground.withOpacity(0.75),
      Level.warning => Colors.yellow.shade600,
      Level.error => Colors.red,
      Level.fatal => Colors.red.shade900,
      _ => c.onBackground,
    };
    final icon = switch (message.level) {
      Level.trace => Icons.troubleshoot,
      Level.debug => Icons.bug_report,
      Level.info => Icons.info_outline,
      Level.warning => Icons.warning,
      Level.error => Icons.error,
      Level.fatal => Icons.error_outline,
      _ => null,
    };
    return Material(
      child: ListTile(
        trailing: Icon(
          icon,
          color: color,
        ),
        tileColor: backgroundColor,
        title: Text(
          message.message,
          style: TextStyle(color: color),
        ),
        subtitle: message.className != null
            ? Text(
                "${message.className ?? ''} ${message.methodName ?? ''}",
                style: TextStyle(
                  color: color.withOpacity(0.75),
                  fontSize: 10,
                  fontFamily: "monospace",
                ),
              )
            : null,
        leading: message.timestamp != null
            ? Text(DateFormat("HH:mm:ss.SSS").format(message.timestamp!))
            : null,
      ),
    );
  }
}
