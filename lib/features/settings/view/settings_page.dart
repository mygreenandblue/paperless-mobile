import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/core/bloc/server_information_cubit.dart';
import 'package:paperless_mobile/core/bloc/server_information_state.dart';
import 'package:paperless_mobile/features/settings/view/pages/application_settings_page.dart';
import 'package:paperless_mobile/features/settings/view/pages/security_settings_page.dart';
import 'package:paperless_mobile/features/settings/view/widgets/user_settings_builder.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.settings),
      ),
      bottomNavigationBar: UserAccountBuilder(
        builder: (context, user) {
          assert(user != null);
          final host = user!.serverUrl.replaceFirst(RegExp(r"https?://"), "");
          return ListTile(
            title: Text(
              S.of(context)!.loggedInAs(user.paperlessUser.username) + "@$host",
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
            subtitle: BlocBuilder<ServerInformationCubit, ServerInformationState>(
              builder: (context, state) {
                return Text(
                  S.of(context)!.paperlessServerVersion +
                      ' ' +
                      state.information!.version.toString() +
                      ' (API v${state.information!.apiVersion})',
                  style: Theme.of(context).textTheme.labelSmall,
                  textAlign: TextAlign.center,
                );
              },
            ),
          );
        },
      ),
      body: ListView(
        children: [
          ListTile(
            // leading: const Icon(Icons.style_outlined),
            title: Text(S.of(context)!.applicationSettings),
            subtitle: Text(S.of(context)!.languageAndVisualAppearance),
            onTap: () => _goto(const ApplicationSettingsPage(), context),
          ),
          ListTile(
            // leading: const Icon(Icons.security_outlined),
            title: Text(S.of(context)!.security),
            subtitle: Text(S.of(context)!.biometricAuthentication),
            onTap: () => _goto(const SecuritySettingsPage(), context),
          ),
          // ListTile(
          //   // leading: const Icon(Icons.storage_outlined),
          //   title: Text(S.of(context)!.storage),
          //   subtitle:
          //       Text(S.of(context)!.mangeFilesAndStorageSpace),
          //   onTap: () => _goto(const StorageSettingsPage(), context),
          // ),
        ],
      ),
    );
  }

  void _goto(Widget page, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
        maintainState: true,
      ),
    );
  }
}
