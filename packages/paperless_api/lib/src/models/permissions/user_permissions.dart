import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:paperless_api/config/hive/hive_type_ids.dart';
part 'user_permissions.g.dart';

@HiveType(typeId: PaperlessApiHiveTypeIds.userPermissions)
@JsonEnum(valueField: "value")
enum UserPermissions {
  @HiveField(0)
  addCorrespondent("add_correspondent"),
  @HiveField(1)
  addDocument("add_document"),
  @HiveField(2)
  addDocumenttype("add_documenttype"),
  @HiveField(3)
  addGroup("add_group"),
  @HiveField(4)
  addMailaccount("add_mailaccount"),
  @HiveField(5)
  addMailrule("add_mailrule"),
  @HiveField(6)
  addNote("add_note"),
  @HiveField(7)
  addPaperlesstask("add_paperlesstask"),
  @HiveField(8)
  addSavedview("add_savedview"),
  @HiveField(9)
  addStoragepath("add_storagepath"),
  @HiveField(10)
  addTag("add_tag"),
  @HiveField(11)
  addUisettings("add_uisettings"),
  @HiveField(12)
  addUser("add_user"),
  @HiveField(13)
  changeCorrespondent("change_correspondent"),
  @HiveField(14)
  changeDocument("change_document"),
  @HiveField(15)
  changeDocumenttype("change_documenttype"),
  @HiveField(16)
  changeGroup("change_group"),
  @HiveField(17)
  changeMailaccount("change_mailaccount"),
  @HiveField(18)
  changeMailrule("change_mailrule"),
  @HiveField(19)
  changeNote("change_note"),
  @HiveField(20)
  changePaperlesstask("change_paperlesstask"),
  @HiveField(21)
  changeSavedview("change_savedview"),
  @HiveField(22)
  changeStoragepath("change_storagepath"),
  @HiveField(23)
  changeTag("change_tag"),
  @HiveField(24)
  changeUisettings("change_uisettings"),
  @HiveField(25)
  changeUser("change_user"),
  @HiveField(26)
  deleteCorrespondent("delete_correspondent"),
  @HiveField(27)
  deleteDocument("delete_document"),
  @HiveField(28)
  deleteDocumenttype("delete_documenttype"),
  @HiveField(29)
  deleteGroup("delete_group"),
  @HiveField(30)
  deleteMailaccount("delete_mailaccount"),
  @HiveField(31)
  deleteMailrule("delete_mailrule"),
  @HiveField(32)
  deleteNote("delete_note"),
  @HiveField(33)
  deletePaperlesstask("delete_paperlesstask"),
  @HiveField(34)
  deleteSavedview("delete_savedview"),
  @HiveField(35)
  deleteStoragepath("delete_storagepath"),
  @HiveField(36)
  deleteTag("delete_tag"),
  @HiveField(37)
  deleteUisettings("delete_uisettings"),
  @HiveField(38)
  deleteUser("delete_user"),
  @HiveField(39)
  viewCorrespondent("view_correspondent"),
  @HiveField(40)
  viewDocument("view_document"),
  @HiveField(41)
  viewDocumenttype("view_documenttype"),
  @HiveField(42)
  viewGroup("view_group"),
  @HiveField(43)
  viewMailaccount("view_mailaccount"),
  @HiveField(44)
  viewMailrule("view_mailrule"),
  @HiveField(45)
  viewNote("view_note"),
  @HiveField(46)
  viewPaperlesstask("view_paperlesstask"),
  @HiveField(47)
  viewSavedview("view_savedview"),
  @HiveField(48)
  viewStoragepath("view_storagepath"),
  @HiveField(49)
  viewTag("view_tag"),
  @HiveField(50)
  viewUisettings("view_uisettings"),
  @HiveField(51)
  viewUser("view_user");

  const UserPermissions(this.value);

  final String value;
}
