import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:paperless_mobile/core/logging/logger.dart';
import 'package:paperless_mobile/helpers/format_helpers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class FileService {
  const FileService._();

  static Future<File> saveToFile(
    Uint8List bytes,
    String filename,
  ) async {
    final dir = await documentsDirectory;
    File file = File("${dir.path}/$filename");
    return file..writeAsBytes(bytes);
  }

  static Future<Directory?> getDirectory(PaperlessDirectoryType type) {
    return switch (type) {
      PaperlessDirectoryType.documents => documentsDirectory,
      PaperlessDirectoryType.temporary => temporaryDirectory,
      PaperlessDirectoryType.scans => temporaryScansDirectory,
      PaperlessDirectoryType.download => downloadsDirectory,
      PaperlessDirectoryType.upload => uploadDirectory,
    };
  }

  static Future<File> allocateTemporaryFile(
    PaperlessDirectoryType type, {
    required String extension,
    String? fileName,
  }) async {
    final dir = await getDirectory(type);
    final _fileName = (fileName ?? const Uuid().v1()) + '.$extension';
    return File('${dir?.path}/$_fileName');
  }

  static Future<Directory> get temporaryDirectory => getTemporaryDirectory();

  static Future<Directory> get documentsDirectory async {
    if (Platform.isAndroid) {
      return (await getExternalStorageDirectories(
        type: StorageDirectory.documents,
      ))!
          .first;
    } else if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory()
          .then((dir) => Directory('${dir.path}/documents'));
      return dir.create(recursive: true);
    } else {
      throw UnsupportedError("Platform not supported.");
    }
  }

  static Future<Directory> get logDirectory async {
    if (Platform.isAndroid) {
      return getExternalStorageDirectories(type: StorageDirectory.documents)
          .then((directory) async =>
              directory?.firstOrNull ??
              await getApplicationDocumentsDirectory())
          .then((directory) =>
              Directory('${directory.path}/logs').create(recursive: true));
    } else if (Platform.isIOS) {
      return getApplicationDocumentsDirectory().then(
          (value) => Directory('${value.path}/logs').create(recursive: true));
    }
    throw UnsupportedError("Platform not supported.");
  }

  static Future<Directory> get downloadsDirectory async {
    if (Platform.isAndroid) {
      var directory = Directory('/storage/emulated/0/Download');
      if (!directory.existsSync()) {
        final downloadsDir = await getExternalStorageDirectories(
          type: StorageDirectory.downloads,
        );
        directory = downloadsDir!.first;
      }
      return directory;
    } else if (Platform.isIOS) {
      final appDir = await getApplicationDocumentsDirectory();
      final dir = Directory('${appDir.path}/downloads');
      return dir.create(recursive: true);
    } else {
      throw UnsupportedError("Platform not supported.");
    }
  }

  static Future<Directory> get uploadDirectory async {
    final dir = await getApplicationDocumentsDirectory()
        .then((dir) => Directory('${dir.path}/upload'));
    return dir.create(recursive: true);
  }

  static Future<Directory> getConsumptionDirectory(
      {required String userId}) async {
    final uploadDir =
        await uploadDirectory.then((dir) => Directory('${dir.path}/$userId'));
    return uploadDir.create(recursive: true);
  }

  static Future<Directory> get temporaryScansDirectory async {
    final tempDir = await temporaryDirectory;
    final scansDir = Directory('${tempDir.path}/scans');
    return scansDir.create(recursive: true);
  }

  static Future<void> clearUserData({required String userId}) async {
    logger.t("FileService#clearUserData(): Clearing data for user $userId...");

    final scanDir = await temporaryScansDirectory;
    final scanDirSize = formatBytes(await getDirSizeInBytes(scanDir));
    final tempDir = await temporaryDirectory;
    final tempDirSize = formatBytes(await getDirSizeInBytes(tempDir));
    final consumptionDir = await getConsumptionDirectory(userId: userId);
    final consumptionDirSize =
        formatBytes(await getDirSizeInBytes(consumptionDir));

    logger.t("FileService#clearUserData(): Removing scans...");
    await scanDir.delete(recursive: true);
    logger.t("FileService#clearUserData(): Removed $scanDirSize...");

    logger.t(
        "FileService#clearUserData(): Removing temporary files and cache content...");

    await tempDir.delete(recursive: true);
    logger.t("FileService#clearUserData(): Removed $tempDirSize...");

    logger.t(
        "FileService#clearUserData(): Removing files waiting for consumption...");
    await consumptionDir.delete(recursive: true);
    logger.t("FileService#clearUserData(): Removed $consumptionDirSize...");
  }

  static Future<void> clearDirectoryContent(PaperlessDirectoryType type) async {
    final dir = await getDirectory(type);

    if (dir == null || !(await dir.exists())) {
      return;
    }

    await Future.wait(
      dir.listSync().map((item) => item.delete(recursive: true)),
    );
  }

  static Future<List<File>> getAllFiles(Directory directory) {
    return directory.list().whereType<File>().toList();
  }

  static Future<List<Directory>> getAllSubdirectories(Directory directory) {
    return directory.list().whereType<Directory>().toList();
  }

  static Future<int> getDirSizeInBytes(Directory dir) async {
    return dir
        .list(recursive: true)
        .fold(0, (previous, element) => previous + element.statSync().size);
  }
}

enum PaperlessDirectoryType {
  documents,
  temporary,
  scans,
  download,
  upload;
}
