import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paperless_mobile/constants.dart';
import 'package:paperless_mobile/core/bloc/paperless_server_information_cubit.dart';
import 'package:paperless_mobile/core/widgets/paperless_logo.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/settings/view/settings_page.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
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
              title: Text(S.of(context)!.reportABug),
              onTap: () {
                launchUrlString('https://github.com/astubenbord/paperless-mobile/issues/new');
              },
            ),
            ListTile(
              dense: true,
              leading: Padding(
                padding: const EdgeInsets.only(left: 3),
                child: SvgPicture.asset(
                  'assets/images/bmc-logo.svg',
                  width: 24,
                  height: 24,
                ),
              ),
              title: Text(S.of(context)!.donateCoffee),
              onTap: () {
                launchUrlString("https://www.buymeacoffee.com/astubenbord");
              },
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.settings_outlined),
              title: Text(
                S.of(context)!.settings,
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<PaperlessServerInformationCubit>(),
                    child: const SettingsPage(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationIcon: const ImageIcon(
        AssetImage('assets/logos/paperless_logo_green.png'),
      ),
      applicationName: 'Paperless Mobile',
      applicationVersion: packageInfo.version + '+' + packageInfo.buildNumber,
      children: [
        Text(S.of(context)!.developedBy('Anton Stubenbord')),
        Link(
          uri: Uri.parse('https://github.com/astubenbord/paperless-mobile'),
          builder: (context, followLink) => GestureDetector(
            onTap: followLink,
            child: Text(
              'https://github.com/astubenbord/paperless-mobile',
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Credits',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        _buildOnboardingImageCredits(),
      ],
    );
  }

  Widget _buildOnboardingImageCredits() {
    return Link(
      uri: Uri.parse(
          'https://www.freepik.com/free-vector/business-team-working-cogwheel-mechanism-together_8270974.htm#query=setting&position=4&from_view=author'),
      builder: (context, followLink) => Wrap(
        children: [
          const Text('Onboarding images by '),
          GestureDetector(
            onTap: followLink,
            child: Text(
              'pch.vector',
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
          ),
          const Text(' on Freepik.')
        ],
      ),
    );
  }
}
