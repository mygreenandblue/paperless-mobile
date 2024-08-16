// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:edocs_mobile/core/service/file_service.dart';
// import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
// import 'package:edocs_mobile/helpers/format_helpers.dart';
// import 'package:edocs_mobile/helpers/message_helpers.dart';

// class ClearCacheSetting extends StatefulWidget {
//   const ClearCacheSetting({super.key});

//   @override
//   State<ClearCacheSetting> createState() => _ClearCacheSettingState();
// }

// class _ClearCacheSettingState extends State<ClearCacheSetting> {
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(S.of(context)!.clearCache),
//       subtitle: FutureBuilder<int>(
//         future: FileService.instance
//             .getDirSizeInBytes(FileService.instance.temporaryDirectory),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Text(S.of(context)!.calculatingDots);
//           }
//           final dirSize = formatBytes(snapshot.data!);
//           return Text(S.of(context)!.freeBytes(dirSize));
//         },
//       ),
//       onTap: () async {
//         final freedBytes = await FileService.instance
//             .clearDirectoryContent(edocsDirectoryType.temporary);
//         showSnackBar(
//           context,
//           S.of(context)!.freedDiskSpace(formatBytes(freedBytes)),
//         );
//       },
//     );
//   }
// }
