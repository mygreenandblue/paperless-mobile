import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/paperless_server_information_cubit.dart';
import 'package:paperless_mobile/core/bloc/paperless_server_information_state.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/widgets/hint_card.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/login/model/user_account.dart';
import 'package:paperless_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class AccountSettingsDialog extends StatelessWidget {
  const AccountSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalSettingsBuilder(builder: (context, globalSettings) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        scrollable: true,
        contentPadding: EdgeInsets.zero,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.of(context)!.account),
            const CloseButton(),
          ],
        ),
        content: BlocBuilder<PaperlessServerInformationCubit, PaperlessServerInformationState>(
          builder: (context, state) {
            return Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: Hive.box<UserAccount>(HiveBoxes.userAccount).listenable(),
                  builder: (context, box, _) {
                    // final currentUser = globalSettings.currentLoggedInUser;
                    final currentUser = null;
                    final accountIds =
                        box.keys.whereNot((element) => element == currentUser).toList();
                    final accounts = accountIds.map((id) => box.get(id)!).toList();
                    return ExpansionTile(
                      leading: CircleAvatar(
                        child: Text(state.information?.userInitials ?? ''),
                      ),
                      title: Text(state.information?.username ?? ''),
                      subtitle: Text(state.information?.host ?? ''),
                      children:
                          accounts.map((account) => _buildAccountTile(account, true)).toList(),
                    );
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.person_add_rounded),
                  title: Text(S.of(context)!.addAnotherAccount),
                  onTap: () {},
                ),
                const Divider(),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.error,
                    ),
                  ),
                  child: Text(
                    S.of(context)!.disconnect,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                  onPressed: () async {
                    await _onLogout(context);
                    Navigator.of(context).maybePop();
                  },
                ).padded(16),
              ],
            );
          },
        ),
      );
    });
  }

  Future<void> _onLogout(BuildContext context) async {
    try {
      await context.read<AuthenticationCubit>().logout();
      await HydratedBloc.storage.clear();
    } on PaperlessServerException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  Widget _buildAccountTile(UserAccount account, bool isActive) {
    return ListTile(
      selected: isActive,
      title: Text(account.username),
      subtitle: Text(account.serverUrl),
      leading: CircleAvatar(
        child: Text((account.fullName ?? account.username)
            .split(" ")
            .take(2)
            .map((e) => e.substring(0, 1))
            .map((e) => e.toUpperCase())
            .join(" ")),
      ),
    );
  }
}
