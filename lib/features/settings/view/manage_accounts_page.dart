import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/login/model/login_form_credentials.dart';
import 'package:paperless_mobile/features/login/model/user_account.dart';
import 'package:paperless_mobile/features/login/view/login_page.dart';
import 'package:paperless_mobile/features/settings/model/global_settings.dart';
import 'package:paperless_mobile/features/settings/view/dialogs/switch_account_dialog.dart';
import 'package:paperless_mobile/features/settings/view/pages/switching_accounts_page.dart';
import 'package:paperless_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:paperless_mobile/features/settings/view/widgets/user_avatar.dart';

class ManageAccountsPage extends StatelessWidget {
  const ManageAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
          title: const Text("Accounts"), //TODO: INTL
        ),
        body: GlobalSettingsBuilder(
          builder: (context, globalSettings) {
            return ValueListenableBuilder(
              valueListenable: Hive.box<UserAccount>(HiveBoxes.userAccount).listenable(),
              builder: (context, box, _) {
                final userIds = box.keys.toList().cast<String>();
                final otherAccounts = userIds
                    .whereNot((element) => element == globalSettings.currentLoggedInUser)
                    .toList();
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your account", //TODO: INTL
                            style: Theme.of(context).textTheme.labelLarge,
                          ).padded(16),
                          _buildAccountTile(
                            context,
                            globalSettings.currentLoggedInUser!,
                            box.get(globalSettings.currentLoggedInUser!)!,
                            globalSettings,
                          ),
                          if (otherAccounts.isNotEmpty) const Divider(),
                        ],
                      ),
                    ),
                    if (otherAccounts.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Text(
                          "Other accounts", //TODO: INTL
                          style: Theme.of(context).textTheme.labelLarge,
                        ).padded(16),
                      ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildAccountTile(
                          context,
                          otherAccounts[index],
                          box.get(otherAccounts[index])!,
                          globalSettings,
                        ),
                        childCount: otherAccounts.length,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const Divider(),
                          ListTile(
                            title: const Text("Add account"),
                            leading: const Icon(Icons.person_add),
                            onTap: () {
                              _onAddAccount(context);
                            },
                          ),
                          // FilledButton.tonalIcon(
                          //   icon: Icon(Icons.person_add),
                          //   label: Text("Add account"),
                          //   onPressed: () {},
                          // ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAccountTile(
    BuildContext context,
    String userId,
    UserAccount account,
    GlobalSettings settings,
  ) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(account.username),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (account.fullName != null) Text(account.fullName!),
          Text(account.serverUrl),
        ],
      ),
      isThreeLine: true,
      leading: UserAvatar(
        account: account,
        userId: userId,
      ),
      trailing: PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        itemBuilder: (context) {
          return [
            if (settings.currentLoggedInUser != userId)
              const PopupMenuItem(
                child: ListTile(
                  title: Text("Switch"), //TODO: INTL
                  leading: Icon(Icons.switch_account_outlined),
                ),
                value: 0,
              ),
            const PopupMenuItem(
              child: ListTile(
                title: Text("Remove"), // TODO: INTL
                leading: Icon(
                  Icons.remove_circle_outline,
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
            final navigator = Navigator.of(context);
            if (settings.currentLoggedInUser == userId) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SwitchingAccountsPage(),
              ),
            );
            await context.read<AuthenticationCubit>().switchAccount(userId);
            navigator.popUntil((route) => route.isFirst);
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
    );
  }

  Future<void> _onAddAccount(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
          titleString: "Add account", //TODO: INTL
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
          submitText: "Add account", //TODO: INTL
        ),
      ),
    );
  }
}
