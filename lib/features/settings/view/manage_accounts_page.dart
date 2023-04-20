import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/login/model/login_form_credentials.dart';
import 'package:paperless_mobile/features/login/model/user_account.dart';
import 'package:paperless_mobile/features/login/view/login_page.dart';
import 'package:paperless_mobile/features/settings/model/global_settings.dart';
import 'package:paperless_mobile/features/settings/view/dialogs/switch_account_dialog.dart';
import 'package:paperless_mobile/features/settings/view/pages/switching_accounts_page.dart';
import 'package:paperless_mobile/features/settings/view/widgets/global_settings_builder.dart';

class ManageAccountsPage extends StatelessWidget {
  const ManageAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: CloseButton(),
          title: Text("Manage Accounts"), //TODO: INTL
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(
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
                    final shoudSwitch = await showDialog(
                          context: context,
                          builder: (context) =>
                              SwitchAccountDialog(username: username, serverUrl: serverUrl),
                        ) ??
                        false;
                    if (shoudSwitch) {
                      context.read<AuthenticationCubit>().switchAccount(userId);
                    }
                  },
                  submitText: "Add account",
                ),
              ),
            );
          },
          label: Text("Add account"),
          icon: Icon(Icons.person_add),
        ),
        body: GlobalSettingsBuilder(
          builder: (context, globalSettings) {
            return ValueListenableBuilder(
              valueListenable: Hive.box<UserAccount>(HiveBoxes.userAccount).listenable(),
              builder: (context, box, _) {
                final userIds = box.keys.toList().cast<String>();
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return _buildAccountTile(
                      context,
                      userIds[index],
                      box.get(userIds[index])!,
                      globalSettings,
                    );
                  },
                  itemCount: userIds.length,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAccountTile(
      BuildContext context, String userId, UserAccount account, GlobalSettings settings) {
    final theme = Theme.of(context);
    return ListTile(
      selected: userId == settings.currentLoggedInUser,
      title: Text(account.username),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (account.fullName != null) Text(account.fullName!),
          Text(account.serverUrl),
        ],
      ),
      isThreeLine: true,
      leading: CircleAvatar(
        child: Text((account.fullName ?? account.username)
            .split(" ")
            .take(2)
            .map((e) => e.substring(0, 1))
            .map((e) => e.toUpperCase())
            .join(" ")),
      ),
      onTap: () async {
        final navigator = Navigator.of(context);
        if (settings.currentLoggedInUser == userId) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SwitchingAccountsPage(),
          ),
        );
        await context.read<AuthenticationCubit>().switchAccount(userId);
        navigator.popUntil((route) => route.isFirst);
      },
      trailing: TextButton(
        child: Text(
          "Remove",
          style: TextStyle(
            color: theme.colorScheme.error,
          ),
        ),
        onPressed: () async {
          final shouldPop = userId == settings.currentLoggedInUser;
          await context.read<AuthenticationCubit>().removeAccount(userId);
          if (shouldPop) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
