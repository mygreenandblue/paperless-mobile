class ApiVersion {
  final int version;

  ApiVersion(this.version);

  bool get supportsPermissions => version >= 3;
  bool get hasMultiUserSupport => version >= 3;
}
