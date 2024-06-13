import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_mobile/constants.dart';
import 'package:edocs_mobile/core/database/tables/local_user_account.dart';
import 'package:edocs_mobile/core/extensions/flutter_extensions.dart';
import 'package:edocs_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:edocs_mobile/features/saved_view/cubit/saved_view_cubit.dart';
import 'package:edocs_mobile/features/sharing/cubit/receive_share_cubit.dart';
import 'package:edocs_mobile/generated/assets.gen.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:edocs_mobile/routing/routes/documents_route.dart';
import 'package:edocs_mobile/routing/routes/saved_views_route.dart';
import 'package:edocs_mobile/routing/routes/settings_route.dart';
import 'package:edocs_mobile/routing/routes/shells/authenticated_route.dart';
import 'package:edocs_mobile/routing/routes/upload_queue_route.dart';
import 'package:edocs_mobile/routing/routes/physical_warehouse_route.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _selectedTileIndex = -1;
  Color _getTitleColor(int tileIndex) {
    return _selectedTileIndex == tileIndex
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    final currentAccount = context.watch<LocalUserAccount>();
    final username = currentAccount.edocsUser.username;
    final serverUrl =
        currentAccount.serverUrl.replaceAll(RegExp(r'https?://'), '');

    return SafeArea(
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const $AssetsLogosGen()
                      .onlyLogoPng
                      .image(width: 32, height: 32),
                  const SizedBox(width: 8),
                  Text(
                    "EDOCS Mobile",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ).paddedLTRB(8, 8, 8, 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context)!.loggedInAs(username),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.5),
                        ),
                  ),
                  Text(
                    serverUrl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.5),
                        ),
                  ),
                ],
              ).paddedSymmetrically(horizontal: 16),
              const Divider(),

              ListTile(
                dense: true,
                title: Text(
                  S.of(context)!.aboutThisApp,
                ),
                leading: const Icon(Icons.info_outline),
                onTap: () => _showAboutDialog(context),
              ),

              // ListTile(
              //   dense: true,
              //   leading: const Icon(Icons.bug_report_outlined),
              //   title: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(S.of(context)!.reportABug),
              //       const Icon(
              //         Icons.open_in_new,
              //         size: 16,
              //       )
              //     ],
              //   ),
              //   onTap: () {
              //     launchUrlString(
              //       'https://github.com/astubenbord/edocs-mobile/issues/new?assignees=astubenbord&labels=bug%2Ctriage&projects=&template=bug-report.yml&title=%5BBug%5D%3A+',
              //       mode: LaunchMode.externalApplication,
              //     );
              //   },
              // ),
              // ListTile(
              //   dense: true,
              //   leading: Assets.images.githubMark.svg(
              //     colorFilter: ColorFilter.mode(
              //       Theme.of(context).colorScheme.onBackground,
              //       BlendMode.srcIn,
              //     ),
              //     height: 24,
              //     width: 24,
              //   ),
              //   title: Text(S.of(context)!.sourceCode),
              //   trailing: const Icon(
              //     Icons.open_in_new,
              //     size: 16,
              //   ),
              //   onTap: () {
              //     launchUrlString(
              //       "https://github.com/astubenbord/edocs-mobile",
              //       mode: LaunchMode.externalApplication,
              //     );
              //   },
              // ),
              Consumer<ConsumptionChangeNotifier>(
                builder: (context, value, child) {
                  final files = value.pendingFiles;
                  final child = ListTile(
                    dense: true,
                    leading: const Icon(Icons.drive_folder_upload_outlined),
                    title: Text(S.of(context)!.pendingFiles),
                    onTap: () {
                      UploadQueueRoute().push(context);
                    },
                    trailing: Text(
                      '${files.length}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                  if (files.isEmpty) {
                    return child;
                  }
                  return child
                      .animate(
                        onPlay: (c) => c.repeat(reverse: true),
                        autoPlay: !MediaQuery.disableAnimationsOf(context),
                      )
                      .fade(duration: 1.seconds, begin: 1, end: 0.3);
                },
              ),
              ListTile(
                dense: true,
                leading: const Icon(Icons.settings_outlined),
                title: Text(
                  S.of(context)!.settings,
                ),
                onTap: () => SettingsRoute().push(context),
              ),
              const Divider(),
              Text(
                S.of(context)!.views,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.labelLarge,
              ).padded(16),
              _buildSavedViews(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavedViews() {
    return BlocBuilder<SavedViewCubit, SavedViewState>(
        builder: (context, state) {
      return state.when(
        initial: () => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
        loaded: (savedViews) {
          final sidebarViews = savedViews.values
              .where((element) => element.showInSidebar)
              .toList();
          if (sidebarViews.isEmpty) {
            return Column(
              children: [
                Text(
                  S.of(context)!.youDidNotSaveAnyViewsYet,
                  style: Theme.of(context).textTheme.bodySmall,
                ).paddedOnly(
                  left: 16,
                  right: 16,
                ),
                TextButton.icon(
                  onPressed: () {
                    Scaffold.of(context).closeDrawer();
                    const CreateSavedViewRoute(showInSidebar: true)
                        .push(context);
                  },
                  icon: const Icon(Icons.add),
                  label: Text(S.of(context)!.newView),
                ),
              ],
            );
          }
          return Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final view = sidebarViews[index];
                return ListTile(
                  title: Text(view.name),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    context
                        .read<DocumentsCubit>()
                        .updateFilter(filter: view.toDocumentFilter());
                    DocumentsRoute().go(context);
                  },
                );
              },
              itemCount: sidebarViews.length,
            ),
          );
        },
        error: () => Text(S.of(context)!.couldNotLoadSavedViews),
      );
    });
  }

  void _showAboutDialog(BuildContext context) {
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;
    showAboutDialog(
      context: context,
      applicationIcon:
          const $AssetsLogosGen().onlyLogoPng.image(width: 32, height: 32),
      applicationName: 'EDOCS Mobile',
      applicationVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
      children: [
        Text(S.of(context)!.developedBy('TC Group')),
      ],
    );
  }

  // Widget _buildOnboardingImageCredits() {
  //   return RichText(
  //     text: TextSpan(
  //       children: [
  //         const TextSpan(
  //           text: 'Onboarding images by ',
  //         ),
  //         TextSpan(
  //           text: 'pch.vector',
  //           style: const TextStyle(color: Colors.blue),
  //           recognizer: TapGestureRecognizer()
  //             ..onTap = () {
  //               launchUrlString(
  //                   'https://www.freepik.com/free-vector/business-team-working-cogwheel-mechanism-together_8270974.htm#query=setting&position=4&from_view=author');
  //             },
  //         ),
  //         const TextSpan(
  //           text: ' on Freepik.',
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

//Wrap(
//   children: [
//     const Text('Onboarding images by '),
//     GestureDetector(
//       onTap: followLink,
//       child: RichText(

//         'pch.vector',
//         style: TextStyle(color: Colors.blue),
//       ),
//     ),
//     const Text(' on Freepik.')
//   ],
// )
