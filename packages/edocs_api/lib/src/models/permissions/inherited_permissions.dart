enum InheritedPermissionGroup {
  admin,
  auth,
  authtoken,
  contenttypes,
  djangoCeleryResults,
  documents,
  guardian,
  edocsMail,
  sessions;
}

// @HiveType(typeId: edocsApiHiveTypeIds.inheritedPermissions)
// @JsonEnum(valueField: "value")
// enum InheritedPermissions {
//   @HiveField(0)
//   adminAddLogentry("admin.add_logentry"),
//   @HiveField(1)
//   adminChangeLogentry("admin.change_logentry"),
//   @HiveField(2)
//   adminDeleteLogentry("admin.delete_logentry"),
//   @HiveField(3)
//   adminViewLogentry("admin.view_logentry"),
//   @HiveField(4)
//   authAddGroup("auth.add_group"),
//   @HiveField(5)
//   authAddPermission("auth.add_permission"),
//   @HiveField(6)
//   authAddUser("auth.add_user"),
//   @HiveField(7)
//   authChangeGroup("auth.change_group"),
//   @HiveField(8)
//   authChangePermission("auth.change_permission"),
//   @HiveField(9)
//   authChangeUser("auth.change_user"),
//   @HiveField(10)
//   authDeleteGroup("auth.delete_group"),
//   @HiveField(11)
//   authDeletePermission("auth.delete_permission"),
//   @HiveField(12)
//   authDeleteUser("auth.delete_user"),
//   @HiveField(13)
//   authViewGroup("auth.view_group"),
//   @HiveField(14)
//   authViewPermission("auth.view_permission"),
//   @HiveField(15)
//   authViewUser("auth.view_user"),
//   @HiveField(16)
//   authtokenAddToken("authtoken.add_token"),
//   @HiveField(17)
//   authtokenAddTokenproxy("authtoken.add_tokenproxy"),
//   @HiveField(18)
//   authtokenChangeToken("authtoken.change_token"),
//   @HiveField(19)
//   authtokenChangeTokenproxy("authtoken.change_tokenproxy"),
//   @HiveField(20)
//   authtokenDeleteToken("authtoken.delete_token"),
//   @HiveField(21)
//   authtokenDeleteTokenproxy("authtoken.delete_tokenproxy"),
//   @HiveField(22)
//   authtokenViewToken("authtoken.view_token"),
//   @HiveField(23)
//   authtokenViewTokenproxy("authtoken.view_tokenproxy"),
//   @HiveField(24)
//   contenttypesAddContenttype("contenttypes.add_contenttype"),
//   @HiveField(25)
//   contenttypesChangeContenttype("contenttypes.change_contenttype"),
//   @HiveField(26)
//   contenttypesDeleteContenttype("contenttypes.delete_contenttype"),
//   @HiveField(27)
//   contenttypesViewContenttype("contenttypes.view_contenttype"),
//   @HiveField(28)
//   djangoCeleryResultsAddChordcounter("django_celery_results.add_chordcounter"),
//   @HiveField(29)
//   djangoCeleryResultsAddGroupresult("django_celery_results.add_groupresult"),
//   @HiveField(30)
//   djangoCeleryResultsAddTaskresult("django_celery_results.add_taskresult"),
//   @HiveField(31)
//   djangoCeleryResultsChangeChordcounter("django_celery_results.change_chordcounter"),
//   @HiveField(32)
//   djangoCeleryResultsChangeGroupresult("django_celery_results.change_groupresult"),
//   @HiveField(33)
//   djangoCeleryResultsChangeTaskresult("django_celery_results.change_taskresult"),
//   @HiveField(34)
//   djangoCeleryResultsDeleteChordcounter("django_celery_results.delete_chordcounter"),
//   @HiveField(35)
//   djangoCeleryResultsDeleteGroupresult("django_celery_results.delete_groupresult"),
//   @HiveField(36)
//   djangoCeleryResultsDeleteTaskresult("django_celery_results.delete_taskresult"),
//   @HiveField(37)
//   djangoCeleryResultsViewChordcounter("django_celery_results.view_chordcounter"),
//   @HiveField(38)
//   djangoCeleryResultsViewGroupresult("django_celery_results.view_groupresult"),
//   @HiveField(39)
//   djangoCeleryResultsViewTaskresult("django_celery_results.view_taskresult"),
//   @HiveField(40)
//   documentsAddComment("documents.add_comment"),
//   @HiveField(41)
//   documentsAddCorrespondent("documents.add_correspondent"),
//   @HiveField(42)
//   documentsAddDocument("documents.add_document"),
//   @HiveField(43)
//   documentsAddDocumenttype("documents.add_documenttype"),
//   @HiveField(44)
//   documentsAddLog("documents.add_log"),
//   @HiveField(45)
//   documentsAddNote("documents.add_note"),
//   @HiveField(46)
//   documentsAddedocstask("documents.add_edocstask"),
//   @HiveField(47)
//   documentsAddSavedview("documents.add_savedview"),
//   @HiveField(48)
//   documentsAddSavedviewfilterrule("documents.add_savedviewfilterrule"),
//   @HiveField(49)
//   documentsAddStoragepath("documents.add_storagepath"),
//   @HiveField(50)
//   documentsAddTag("documents.add_tag"),
//   @HiveField(51)
//   documentsAddUisettings("documents.add_uisettings"),
//   @HiveField(52)
//   documentsChangeComment("documents.change_comment"),
//   @HiveField(53)
//   documentsChangeCorrespondent("documents.change_correspondent"),
//   @HiveField(54)
//   documentsChangeDocument("documents.change_document"),
//   @HiveField(55)
//   documentsChangeDocumenttype("documents.change_documenttype"),
//   @HiveField(56)
//   documentsChangeLog("documents.change_log"),
//   @HiveField(57)
//   documentsChangeNote("documents.change_note"),
//   @HiveField(58)
//   documentsChangeedocstask("documents.change_edocstask"),
//   @HiveField(59)
//   documentsChangeSavedview("documents.change_savedview"),
//   @HiveField(60)
//   documentsChangeSavedviewfilterrule("documents.change_savedviewfilterrule"),
//   @HiveField(61)
//   documentsChangeStoragepath("documents.change_storagepath"),
//   @HiveField(111)
//   documentsChangeTag("documents.change_tag"),
//   @HiveField(62)
//   documentsChangeUisettings("documents.change_uisettings"),
//   @HiveField(63)
//   documentsDeleteComment("documents.delete_comment"),
//   @HiveField(64)
//   documentsDeleteCorrespondent("documents.delete_correspondent"),
//   @HiveField(65)
//   documentsDeleteDocument("documents.delete_document"),
//   @HiveField(66)
//   documentsDeleteDocumenttype("documents.delete_documenttype"),
//   @HiveField(67)
//   documentsDeleteLog("documents.delete_log"),
//   @HiveField(68)
//   documentsDeleteNote("documents.delete_note"),
//   @HiveField(69)
//   documentsDeleteedocstask("documents.delete_edocstask"),
//   @HiveField(70)
//   documentsDeleteSavedview("documents.delete_savedview"),
//   @HiveField(71)
//   documentsDeleteSavedviewfilterrule("documents.delete_savedviewfilterrule"),
//   @HiveField(72)
//   documentsDeleteStoragepath("documents.delete_storagepath"),
//   @HiveField(73)
//   documentsDeleteTag("documents.delete_tag"),
//   @HiveField(74)
//   documentsDeleteUisettings("documents.delete_uisettings"),
//   @HiveField(75)
//   documentsViewComment("documents.view_comment"),
//   @HiveField(76)
//   documentsViewCorrespondent("documents.view_correspondent"),
//   @HiveField(77)
//   documentsViewDocument("documents.view_document"),
//   @HiveField(78)
//   documentsViewDocumenttype("documents.view_documenttype"),
//   @HiveField(79)
//   documentsViewLog("documents.view_log"),
//   @HiveField(80)
//   documentsViewNote("documents.view_note"),
//   @HiveField(81)
//   documentsViewedocstask("documents.view_edocstask"),
//   @HiveField(82)
//   documentsViewSavedview("documents.view_savedview"),
//   @HiveField(83)
//   documentsViewSavedviewfilterrule("documents.view_savedviewfilterrule"),
//   @HiveField(84)
//   documentsViewStoragepath("documents.view_storagepath"),
//   @HiveField(85)
//   documentsViewTag("documents.view_tag"),
//   @HiveField(86)
//   documentsViewUisettings("documents.view_uisettings"),
//   @HiveField(87)
//   guardianAddGroupobjectpermission("guardian.add_groupobjectpermission"),
//   @HiveField(88)
//   guardianAddUserobjectpermission("guardian.add_userobjectpermission"),
//   @HiveField(89)
//   guardianChangeGroupobjectpermission("guardian.change_groupobjectpermission"),
//   @HiveField(90)
//   guardianChangeUserobjectpermission("guardian.change_userobjectpermission"),
//   @HiveField(91)
//   guardianDeleteGroupobjectpermission("guardian.delete_groupobjectpermission"),
//   @HiveField(92)
//   guardianDeleteUserobjectpermission("guardian.delete_userobjectpermission"),
//   @HiveField(93)
//   guardianViewGroupobjectpermission("guardian.view_groupobjectpermission"),
//   @HiveField(94)
//   guardianViewUserobjectpermission("guardian.view_userobjectpermission"),
//   @HiveField(95)
//   edocsMailAddMailaccount("edocs_mail.add_mailaccount"),
//   @HiveField(96)
//   edocsMailAddMailrule("edocs_mail.add_mailrule"),
//   @HiveField(97)
//   edocsMailAddProcessedmail("edocs_mail.add_processedmail"),
//   @HiveField(98)
//   edocsMailChangeMailaccount("edocs_mail.change_mailaccount"),
//   @HiveField(99)
//   edocsMailChangeMailrule("edocs_mail.change_mailrule"),
//   @HiveField(100)
//   edocsMailChangeProcessedmail("edocs_mail.change_processedmail"),
//   @HiveField(101)
//   edocsMailDeleteMailaccount("edocs_mail.delete_mailaccount"),
//   @HiveField(102)
//   edocsMailDeleteMailrule("edocs_mail.delete_mailrule"),
//   @HiveField(103)
//   edocsMailDeleteProcessedmail("edocs_mail.delete_processedmail"),
//   @HiveField(104)
//   edocsMailViewMailaccount("edocs_mail.view_mailaccount"),
//   @HiveField(105)
//   edocsMailViewMailrule("edocs_mail.view_mailrule"),
//   @HiveField(106)
//   edocsMailViewProcessedmail("edocs_mail.view_processedmail"),
//   @HiveField(107)
//   sessionsAddSession("sessions.add_session"),
//   @HiveField(108)
//   sessionsChangeSession("sessions.change_session"),
//   @HiveField(109)
//   sessionsDeleteSession("sessions.delete_session"),
//   @HiveField(110)
//   sessionsViewSession("sessions.view_session");

//   const InheritedPermissions(this.value);
//   final String value;
// }
