import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/paperless_server_information_cubit.dart';
import 'package:paperless_mobile/core/bloc/paperless_server_information_state.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/repository/saved_view_repository.dart';
import 'package:paperless_mobile/core/widgets/hint_card.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/settings/cubit/application_settings_cubit.dart';
import 'package:paperless_mobile/generated/l10n.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class AccountSettingsDialog extends StatelessWidget {
  const AccountSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(S.of(context).accountSettingsTitle),
          const CloseButton(),
        ],
      ),
      content: BlocBuilder<PaperlessServerInformationCubit,
          PaperlessServerInformationState>(
        builder: (context, state) {
          return Column(
            children: [
              ExpansionTile(
                leading: CircleAvatar(
                  child: Text(state.information?.username
                          ?.toUpperCase()
                          .substring(0, 1) ??
                      ''),
                ),
                title: Text(state.information?.username ?? ''),
                subtitle: Text(state.information?.host ?? ''),
                children: const [
                  HintCard(
                    hintText: "WIP: Coming soon with multi user support!",
                  ),
                ],
              ),
              const Divider(),
              ListTile(
                dense: true,
                leading: const Icon(Icons.person_add_rounded),
                title: Text(S.of(context).accountSettingsAddAnotherAccount),
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
                  S.of(context).appDrawerLogoutLabel,
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
  }

  Future<void> _onLogout(BuildContext context) async {
    try {
      await context.read<AuthenticationCubit>().logout();
      await context.read<ApplicationSettingsCubit>().clear();
      await context.read<LabelRepository<Tag>>().clear();
      await context.read<LabelRepository<Correspondent>>().clear();
      await context.read<LabelRepository<DocumentType>>().clear();
      await context.read<LabelRepository<StoragePath>>().clear();
      await context.read<SavedViewRepository>().clear();
      await HydratedBloc.storage.clear();
    } on PaperlessServerException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }
}
