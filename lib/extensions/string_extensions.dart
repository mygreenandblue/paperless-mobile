extension SizeLimitedString on String {
  String withLengthLimitedTo(int length, [String overflow = "..."]) {
    return this.length > length
        ? '${substring(0, length - overflow.length)}$overflow'
        : this;
  }
}
