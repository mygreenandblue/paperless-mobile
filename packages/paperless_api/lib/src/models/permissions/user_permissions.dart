enum PermissionAction {
  add("add"),
  change("change"),
  delete("delete"),
  view("view");

  final String value;
  const PermissionAction(this.value);
}

enum PermissionTarget {
  correspondent("correspondent"),
  document("document"),
  documentType("documenttype"),
  group("group"),
  mailAccount("mailaccount"),
  mailrule("mailrule"),
  note("note"),
  paperlesstask("paperlesstask"),
  savedView("savedview"),
  storagePath("storagepath"),
  tag("tag"),
  uiSettings("uisettings"),
  user("user"),
  logentry("logentry"),
  permission("permission"),

  warehouse("warehouse"),
  shelf("shelf"),
  briefcase("briefcase");

  final String value;
  const PermissionTarget(this.value);
}
