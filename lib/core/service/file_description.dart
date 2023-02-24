class FileDescription {
  final String filename;
  final String extension;

  FileDescription({
    required this.filename,
    required this.extension,
  });

  factory FileDescription.fromPath(String path) {
    final filename = path.split(RegExp(r"/")).last;
    final fragments = filename.split(".");
    final ext = fragments.removeLast();
    final name = fragments.join(".");
    return FileDescription(
      filename: name,
      extension: ext,
    );
  }
}
