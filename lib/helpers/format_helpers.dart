String formatMaxCount(int? count, [int maxCount = 99]) {
  if ((count ?? 0) > maxCount) {
    return "$maxCount+";
  }
  return (count ?? 0).toString().padLeft(maxCount.toString().length);
}
