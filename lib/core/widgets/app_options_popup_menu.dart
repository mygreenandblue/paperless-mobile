// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:paperless_mobile/constants.dart';
// import 'package:paperless_mobile/features/settings/bloc/application_settings_cubit.dart';
// import 'package:paperless_mobile/features/settings/bloc/application_settings_state.dart';
// import 'package:paperless_mobile/features/settings/model/view_type.dart';
// import 'package:paperless_mobile/features/settings/view/settings_page.dart';
// import 'package:paperless_mobile/generated/l10n.dart';
// import 'package:url_launcher/link.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// /// Declares selectable actions in menu.
// enum AppPopupMenuEntries {
//   // Documents preview
//   documentsSelectListView,
//   documentsSelectGridView,
//   // Generic actions
//   openAboutThisAppDialog,
//   reportBug,
//   openSettings,
//   // Adds a divider
//   divider;
// }

// class AppOptionsPopupMenu extends StatelessWidget {
//   final List<AppPopupMenuEntries> displayedActions;
//   const AppOptionsPopupMenu({
//     super.key,
//     required this.displayedActions,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<AppPopupMenuEntries>(
//       position: PopupMenuPosition.under,
//       icon: const Icon(Icons.more_vert),
//       onSelected: (action) {
//         switch (action) {
//           case AppPopupMenuEntries.documentsSelectListView:
//             context.read<ApplicationSettingsCubit>().setViewType(ViewType.list);
//             break;
//           case AppPopupMenuEntries.documentsSelectGridView:
//             context.read<ApplicationSettingsCubit>().setViewType(ViewType.grid);
//             break;
//           case AppPopupMenuEntries.openAboutThisAppDialog:
//             _showAboutDialog(context);
//             break;
//           case AppPopupMenuEntries.openSettings:
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => BlocProvider.value(
//                   value: context.read<ApplicationSettingsCubit>(),
//                   child: const SettingsPage(),
//                 ),
//               ),
//             );
//             break;
//           case AppPopupMenuEntries.reportBug:
//             launchUrlString(
//               'https://github.com/astubenbord/paperless-mobile/issues/new',
//             );
//             break;
//           default:
//             break;
//         }
//       },
//       itemBuilder: _buildEntries,
//     );
//   }

//   PopupMenuItem<AppPopupMenuEntries> _buildReportBugTile(BuildContext context) {
//     return PopupMenuItem(
//       value: AppPopupMenuEntries.reportBug,
//       padding: EdgeInsets.zero,
//       child: ListTile(
//         leading: const Icon(Icons.bug_report),
//         title: Text(S.of(context).reportABug),
//       ),
//     );
//   }

//   PopupMenuItem<AppPopupMenuEntries> _buildSettingsTile(BuildContext context) {
//     return PopupMenuItem(
//       padding: EdgeInsets.zero,
//       value: AppPopupMenuEntries.openSettings,
//       child: ListTile(
//         leading: const Icon(Icons.settings_outlined),
//         title: Text(S.of(context).settings),
//       ),
//     );
//   }

//   PopupMenuItem<AppPopupMenuEntries> _buildAboutTile(BuildContext context) {
//     return PopupMenuItem(
//       padding: EdgeInsets.zero,
//       value: AppPopupMenuEntries.openAboutThisAppDialog,
//       child: ListTile(
//         leading: const Icon(Icons.info_outline),
//         title: Text(S.of(context).aboutThisApp),
//       ),
//     );
//   }

//   PopupMenuItem<AppPopupMenuEntries> _buildListViewTile() {
//     return PopupMenuItem(
//       padding: EdgeInsets.zero,
//       child: BlocBuilder<ApplicationSettingsCubit, ApplicationSettingsState>(
//         builder: (context, state) {
//           return ListTile(
//             leading: const Icon(Icons.list),
//             title: const Text("List"),
//             trailing: state.preferredViewType == ViewType.list
//                 ? const Icon(Icons.check)
//                 : null,
//           );
//         },
//       ),
//       value: AppPopupMenuEntries.documentsSelectListView,
//     );
//   }

//   PopupMenuItem<AppPopupMenuEntries> _buildGridViewTile() {
//     return PopupMenuItem(
//       value: AppPopupMenuEntries.documentsSelectGridView,
//       padding: EdgeInsets.zero,
//       child: BlocBuilder<ApplicationSettingsCubit, ApplicationSettingsState>(
//         builder: (context, state) {
//           return ListTile(
//             leading: const Icon(Icons.grid_view_rounded),
//             title: const Text("Grid"),
//             trailing: state.preferredViewType == ViewType.grid
//                 ? const Icon(Icons.check)
//                 : null,
//           );
//         },
//       ),
//     );
//   }

//   void _showAboutDialog(BuildContext context) {
//     showAboutDialog(
//       context: context,
//       applicationIcon: const ImageIcon(
//         AssetImage('assets/logos/paperless_logo_green.png'),
//       ),
//       applicationName: 'Paperless Mobile',
//       applicationVersion: packageInfo.version + '+' + packageInfo.buildNumber,
//       children: [
//         Text(S.of(context).developedBy('Anton Stubenbord')),
//         Link(
//           uri: Uri.parse('https://github.com/astubenbord/paperless-mobile'),
//           builder: (context, followLink) => GestureDetector(
//             onTap: followLink,
//             child: Text(
//               'https://github.com/astubenbord/paperless-mobile',
//               style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Text(
//           'Credits',
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//         _buildOnboardingImageCredits(),
//       ],
//     );
//   }

//   Widget _buildOnboardingImageCredits() {
//     return Link(
//       uri: Uri.parse(
//           'https://www.freepik.com/free-vector/business-team-working-cogwheel-mechanism-together_8270974.htm#query=setting&position=4&from_view=author'),
//       builder: (context, followLink) => Wrap(
//         children: [
//           const Text('Onboarding images by '),
//           GestureDetector(
//             onTap: followLink,
//             child: Text(
//               'pch.vector',
//               style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
//             ),
//           ),
//           const Text(' on Freepik.')
//         ],
//       ),
//     );
//   }

//   List<PopupMenuEntry<AppPopupMenuEntries>> _buildEntries(
//       BuildContext context) {
//     List<PopupMenuEntry<AppPopupMenuEntries>> items = [];
//     for (final entry in displayedActions) {
//       switch (entry) {
//         case AppPopupMenuEntries.documentsSelectListView:
//           items.add(_buildListViewTile());
//           break;
//         case AppPopupMenuEntries.documentsSelectGridView:
//           items.add(_buildGridViewTile());
//           break;
//         case AppPopupMenuEntries.openAboutThisAppDialog:
//           items.add(_buildAboutTile(context));
//           break;
//         case AppPopupMenuEntries.reportBug:
//           items.add(_buildReportBugTile(context));
//           break;
//         case AppPopupMenuEntries.openSettings:
//           items.add(_buildSettingsTile(context));
//           break;
//         case AppPopupMenuEntries.divider:
//           items.add(const PopupMenuDivider());
//           break;
//       }
//     }
//     return items;
//   }
// }
