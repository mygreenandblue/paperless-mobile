class ApiVersion {
  final int version;

  ApiVersion(this.version);

  bool get hasMultiUserSupport => version >= 3;
}
