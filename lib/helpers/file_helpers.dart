String extractFilenameFromPath(String path) {
  return path.split(RegExp('[./]')).reversed.skip(1).first;
}
