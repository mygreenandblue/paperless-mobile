import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/global_settings.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/login/model/login_form_credentials.dart';
import 'package:paperless_mobile/features/login/view/login_page.dart';
import 'package:paperless_mobile/features/settings/view/dialogs/switch_account_dialog.dart';
import 'package:paperless_mobile/features/settings/view/pages/switching_accounts_page.dart';
import 'package:paperless_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:paperless_mobile/features/settings/view/widgets/user_avatar.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class ManageAccountsPage extends StatelessWidget {
  const ManageAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalSettingsBuilder(
      builder: (context, globalSettings) {
        return ValueListenableBuilder(
          valueListenable: Hive.box<LocalUserAccount>(HiveBoxes.localUserAccount).listenable(),
          builder: (context, box, _) {
            final userIds = box.keys.toList().cast<String>();
            final otherAccounts = userIds
                .whereNot((element) => element == globalSettings.currentLoggedInUser)
                .toList();
            return SimpleDialog(
              insetPadding: const EdgeInsets.all(24),
              contentPadding: const EdgeInsets.all(8),
              title: Stack(
                alignment: Alignment.center,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: CloseButton(),
                  ),
                  Center(child: Text(S.of(context)!.accounts)),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              children: [
                _buildAccountTile(context, globalSettings.currentLoggedInUser!,
                    box.get(globalSettings.currentLoggedInUser!)!, globalSettings),
                // if (otherAccounts.isNotEmpty) Text("Other accounts"),
                Column(
                  children: [
                    for (int index = 0; index < otherAccounts.length; index++)
                      _buildAccountTile(
                        context,
                        otherAccounts[index],
                        box.get(otherAccounts[index])!,
                        globalSettings,
                      ),
                  ],
                ),
                const Divider(),
                ListTile(
                  title: Text(S.of(context)!.addAccount),
                  leading: const Icon(Icons.person_add),
                  onTap: () {
                    _onAddAccount(context, globalSettings.currentLoggedInUser!);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAccountTile(
    BuildContext context,
    String userId,
    LocalUserAccount account,
    GlobalSettings settings,
  ) {
    final isLoggedIn = userId == settings.currentLoggedInUser;
    final theme = Theme.of(context);
    final child = SizedBox(
      width: double.maxFinite,
      child: ListTile(
        title: Text(account.username),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (account.fullName != null) Text(account.fullName!),
            Text(
              account.serverUrl.replaceFirst(RegExp(r'https://?'), ''),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        isThreeLine: account.fullName != null,
        leading: UserAvatar(
          account: account,
          userId: userId,
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) {
            return [
              if (!isLoggedIn)
                PopupMenuItem(
                  child: ListTile(
                    title: Text(S.of(context)!.switchAccount),
                    leading: const Icon(Icons.switch_account_rounded),
                  ),
                  value: 0,
                ),
              if (!isLoggedIn)
                PopupMenuItem(
                  child: ListTile(
                    title: Text(S.of(context)!.remove),
                    leading: const Icon(
                      Icons.person_remove,
                      color: Colors.red,
                    ),
                  ),
                  value: 1,
                )
              else
                PopupMenuItem(
                  child: ListTile(
                    title: Text(S.of(context)!.logout),
                    leading: const Icon(
                      Icons.person_remove,
                      color: Colors.red,
                    ),
                  ),
                  value: 1,
                ),
            ];
          },
          onSelected: (value) async {
            if (value == 0) {
              // Switch
              _onSwitchAccount(context, settings.currentLoggedInUser!, userId);
            } else if (value == 1) {
              // Remove
              final shouldPop = userId == settings.currentLoggedInUser;
              await context.read<AuthenticationCubit>().removeAccount(userId);
              if (shouldPop) {
                Navigator.pop(context);
              }
            }
          },
        ),
      ),
    );
    if (isLoggedIn) {
      return Card(
        child: child,
      );
    }
    return child;
  }

  Future<void> _onAddAccount(BuildContext context, String currentUser) async {
    final userId = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
          titleString: S.of(context)!.addAccount,
          onSubmit: (context, username, password, serverUrl, clientCertificate) async {
            final userId = await context.read<AuthenticationCubit>().addAccount(
                  credentials: LoginFormCredentials(
                    username: username,
                    password: password,
                  ),
                  clientCertificate: clientCertificate,
                  serverUrl: serverUrl,
                  //TODO: Ask user whether to enable biometric authentication
                  enableBiometricAuthentication: false,
                );
            Navigator.of(context).pop<String?>(userId);
          },
          submitText: S.of(context)!.addAccount,
        ),
      ),
    );
    if (userId != null) {
      final shoudSwitch = await showDialog<bool>(
            context: context,
            builder: (context) => const SwitchAccountDialog(),
          ) ??
          false;
      if (shoudSwitch) {
        _onSwitchAccount(context, currentUser, userId);
      }
    }
  }

  _onSwitchAccount(BuildContext context, String currentUser, String newUser) async {
    final navigator = Navigator.of(context);
    if (currentUser == newUser) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SwitchingAccountsPage(),
      ),
    );
    await context.read<AuthenticationCubit>().switchAccount(newUser);
    navigator.popUntil((route) => route.isFirst);
  }
}
