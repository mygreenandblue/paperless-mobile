// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:isolate';

class SynchronousSettingPage extends StatefulWidget {
  final Directory directory;

  const SynchronousSettingPage({super.key, required this.directory});

  @override
  _SynchronousSettingPageState createState() => _SynchronousSettingPageState();
}

class _SynchronousSettingPageState extends State<SynchronousSettingPage> {
  List<FileSystemEntity> files = [];
  String asynchronousPath = '';
  int? selectedIndex;
  final List<String> allowedExtensions = [
    'txt',
    'jpg',
    'jpeg',
    'docx',
    'png',
    'pdf',
    'mp3',
    'mp4'
  ];

  @override
  void initState() {
    super.initState();
    asynchronousPath = widget.directory.path;
    _listFolder();
  }

  void _listFolder() async {
    try {
      List<FileSystemEntity> fileList = await widget.directory.list().toList();
      List<FileSystemEntity> accessibleFiles = [];

      for (FileSystemEntity file in fileList) {
        try {
          if (FileSystemEntity.isDirectorySync(file.path)) {
            accessibleFiles.add(file);
          }
        } catch (e) {
          // Handle permission error or other exceptions
          print("Error checking if directory: $e");
        }
      }

      setState(() {
        files = accessibleFiles;
      });
    } catch (e) {
      // Handle the error when listing the directory itself fails
      print("Error listing directory: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.directory.path),
        actions: [
          TextButton(
              onPressed: () {
                print(asynchronousPath);
              },
              child: const Text(
                'Tải lên',
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          FileSystemEntity file = files[index];

          return ListTile(
            title: Text(file.path.split('/').last),
            trailing: const Icon(Icons.folder_open_outlined),
            tileColor:
                selectedIndex == index ? Colors.green.withOpacity(0.3) : null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SynchronousSettingPage(directory: Directory(file.path)),
                ),
              );
            },
            onLongPress: () {
              setState(() {
                selectedIndex = index;
                asynchronousPath = file.path;
              });
            },
          );
        },
      ),
    );
  }

  void run() {
    final receivePort = ReceivePort();
    Isolate.spawn(backgroundService, receivePort.sendPort);

    receivePort.listen((message) {
      print('Received message: $message');
    });

    // Keep the main function running to allow background service to continue
    Timer.periodic(Duration(seconds: 1), (_) {});
  }

  void backgroundService(
    SendPort sendPort,
  ) async {
    final directoryToWatch = Directory(
        'C:\\Users\\admin\\Documents\\Zalo Received Files\\New folder');
    final uploadUrl = 'http://192.168.1.208:2000/manager_student/uploadfile/';

    try {
      if (!await directoryToWatch.exists()) {
        sendPort.send('Directory does not exist.');
        return;
      }

      sendPort.send('Scanning ${directoryToWatch.path} for files.');
      List<FileSystemEntity> fileList = await directoryToWatch.list().toList();
      List<FileSystemEntity> accessibleFiles = [];

      for (FileSystemEntity file in fileList) {
        try {
          if (FileSystemEntity.isFileSync(file.path)) {
            String extension = file.path.split('.').last.toLowerCase();
            if (allowedExtensions.contains(extension)) {
              accessibleFiles.add(file);
            }
          }
        } catch (e) {
          sendPort.send('Error accessing file: ${file.path}, Error: $e');
        }
      }

      sendPort.send('Found ${accessibleFiles.length} files to upload.');

      for (FileSystemEntity fileEntity in accessibleFiles) {
        final file = File(fileEntity.path);
        if (await file.exists()) {
          sendPort.send('Uploading file: ${file.path}');
          await streamUploadFile(file, uploadUrl, sendPort);
        } else {
          sendPort.send('File no longer exists: ${file.path}');
        }
      }

      sendPort.send('All files processed.');
    } catch (e, stackTrace) {
      sendPort.send('Error in background service: $e\nStackTrace: $stackTrace');
    }
  }

  Future<void> streamUploadFile(
      File file, String url, SendPort sendPort) async {
    try {
      final dio = Dio();
      final stream = file.openRead();
      final length = await file.length();

      sendPort.send(
          'Preparing to upload file: ${file.path} with size: $length bytes');

      final formData = FormData();
      formData.files.add(MapEntry(
        'file',
        MultipartFile(
          stream,
          length,
          filename: file.uri.pathSegments.last,
        ),
      ));

      sendPort.send('FormData prepared for file: ${file.path}');

      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            Headers.contentLengthHeader: length,
          },
        ),
        onSendProgress: (int sent, int total) {
          final progress = ((sent / total) * 100).toStringAsFixed(2);
          sendPort.send('Uploading ${file.path}: $progress% complete');
        },
      );

      if (response.statusCode == 200) {
        sendPort.send('File uploaded successfully: ${file.path}');
      } else {
        sendPort.send(
            'Failed to upload file: ${file.path}. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      sendPort.send(
          'Error uploading file: ${file.path}\nError: $e\nStackTrace: $stackTrace');
    }
  }
}

const List<String> allowedExtensions = ['jpg', 'png', 'pdf', 'docx'];
