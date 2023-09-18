import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paperless_mobile/constants.dart';
import 'package:paperless_mobile/core/widgets/paperless_logo.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routes/typed/top_level/settings_route.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Row(
              children: [
                const PaperlessLogo.green(),
                Text(
                  "Paperless Mobile",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ).padded(),
            const Divider(),
            ListTile(
              dense: true,
              title: Text(S.of(context)!.aboutThisApp),
              leading: const Icon(Icons.info_outline),
              onTap: () => _showAboutDialog(context),
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.bug_report_outlined),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context)!.reportABug),
                  const Icon(
                    Icons.open_in_new,
                    size: 16,
                  )
                ],
              ),
              onTap: () {
                launchUrlString(
                  'https://github.com/astubenbord/paperless-mobile/issues/new',
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.favorite_outline),
              title: Text(S.of(context)!.donate),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    icon: const Icon(Icons.favorite),
                    title: Text(S.of(context)!.donate),
                    content: Text(
                      S.of(context)!.donationDialogContent,
                    ),
                    actions: const [
                      Text("~ Anton"),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              dense: true,
              leading: SvgPicture.asset(
                "assets/images/github-mark.svg",
                color: Theme.of(context).colorScheme.onBackground,
                height: 24,
                width: 24,
              ),
              title: Text(S.of(context)!.sourceCode),
              trailing: const Icon(
                Icons.open_in_new,
                size: 16,
              ),
              onTap: () {
                launchUrlString(
                  "https://github.com/astubenbord/paperless-mobile",
                  mode: LaunchMode.externalApplication,
                );
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
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    showAboutDialog(
      context: context,
      applicationIcon: const ImageIcon(
        AssetImage('assets/logos/paperless_logo_green.png'),
      ),
      applicationName: 'Paperless Mobile',
      applicationVersion: packageInfo.version + '+' + packageInfo.buildNumber,
      children: [
        Text(S.of(context)!.developedBy('Anton Stubenbord')),
        const SizedBox(height: 16),
        Text(
          "Source Code",
          style: theme.textTheme.titleMedium,
        ),
        RichText(
          text: TextSpan(
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurface),
            children: [
              TextSpan(
                text: S.of(context)!.findTheSourceCodeOn,
              ),
              TextSpan(
                text: ' GitHub',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrlString(
                      'https://github.com/astubenbord/paperless-mobile',
                      mode: LaunchMode.externalApplication,
                    );
                  },
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Credits',
          style: theme.textTheme.titleMedium
              ?.copyWith(color: colorScheme.onSurface),
        ),
        RichText(
          text: TextSpan(
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurface),
            children: [
              const TextSpan(
                text: 'Onboarding images by ',
              ),
              TextSpan(
                text: 'pch.vector',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrlString(
                        'https://www.freepik.com/free-vector/business-team-working-cogwheel-mechanism-together_8270974.htm#query=setting&position=4&from_view=author');
                  },
              ),
              const TextSpan(
                text: ' on Freepik.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOnboardingImageCredits() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Onboarding images by ',
          ),
          TextSpan(
            text: 'pch.vector',
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrlString(
                    'https://www.freepik.com/free-vector/business-team-working-cogwheel-mechanism-together_8270974.htm#query=setting&position=4&from_view=author');
              },
          ),
          const TextSpan(
            text: ' on Freepik.',
          ),
        ],
      ),
    );
  }
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
