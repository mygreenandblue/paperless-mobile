import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/paperless_server_information_cubit.dart';
import 'package:paperless_mobile/core/bloc/paperless_server_information_state.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/repository/saved_view_repository.dart';
import 'package:paperless_mobile/core/repository/state/impl/correspondent_repository_state.dart';
import 'package:paperless_mobile/core/repository/state/impl/document_type_repository_state.dart';
import 'package:paperless_mobile/core/repository/state/impl/storage_path_repository_state.dart';
import 'package:paperless_mobile/core/repository/state/impl/tag_repository_state.dart';
import 'package:paperless_mobile/features/login/bloc/authentication_cubit.dart';
import 'package:paperless_mobile/features/settings/bloc/application_settings_cubit.dart';
import 'package:paperless_mobile/features/settings/view/pages/application_settings_page.dart';
import 'package:paperless_mobile/features/settings/view/pages/security_settings_page.dart';
import 'package:paperless_mobile/features/settings/view/pages/storage_settings_page.dart';
import 'package:paperless_mobile/generated/l10n.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appDrawerSettingsLabel),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Theme.of(context).colorScheme.error,
            onPressed: () async {
              await _onLogout(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<PaperlessServerInformationCubit,
          PaperlessServerInformationState>(
        builder: (context, state) {
          final info = state.information!;

          return ListTile(
            title: Text(
              S.of(context).appDrawerHeaderLoggedInAsText +
                  " " +
                  (info.username ?? 'unknown') +
                  "@${info.host}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            subtitle: Text(
              S.of(context).serverInformationPaperlessVersionText +
                  ' ' +
                  info.version.toString() +
                  ' (API v${info.apiVersion})',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        },
      ),
      body: ListView(
        children: [
          ListTile(
            // leading: const Icon(Icons.style_outlined),
            title: Text(S.of(context).settingsPageApplicationSettingsLabel),
            subtitle: Text(
                S.of(context).settingsPageApplicationSettingsDescriptionText),
            onTap: () => _goto(const ApplicationSettingsPage(), context),
          ),
          ListTile(
            // leading: const Icon(Icons.security_outlined),
            title: Text(S.of(context).settingsPageSecuritySettingsLabel),
            subtitle:
                Text(S.of(context).settingsPageSecuritySettingsDescriptionText),
            onTap: () => _goto(const SecuritySettingsPage(), context),
          ),
          ListTile(
            // leading: const Icon(Icons.storage_outlined),
            title: Text(S.of(context).settingsPageStorageSettingsLabel),
            subtitle:
                Text(S.of(context).settingsPageStorageSettingsDescriptionText),
            onTap: () => _goto(const StorageSettingsPage(), context),
          ),
        ],
      ),
    );
  }

  void _goto(Widget page, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<ApplicationSettingsCubit>(),
          child: page,
        ),
        maintainState: true,
      ),
    );
  }

  Future<void> _onLogout(BuildContext context) async {
    try {
      await context.read<AuthenticationCubit>().logout();
      await context.read<ApplicationSettingsCubit>().clear();
      await context.read<LabelRepository<Tag, TagRepositoryState>>().clear();
      await context
          .read<LabelRepository<Correspondent, CorrespondentRepositoryState>>()
          .clear();
      await context
          .read<LabelRepository<DocumentType, DocumentTypeRepositoryState>>()
          .clear();
      await context
          .read<LabelRepository<StoragePath, StoragePathRepositoryState>>()
          .clear();
      await context.read<SavedViewRepository>().clear();
      await HydratedBloc.storage.clear();
    } on PaperlessServerException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }
}
