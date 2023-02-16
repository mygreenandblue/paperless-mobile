import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/repository/saved_view_repository.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/settings/cubit/application_settings_cubit.dart';
import 'package:paperless_mobile/generated/l10n.dart';
import 'package:provider/provider.dart';

class VerifyIdentityPage extends StatelessWidget {
  const VerifyIdentityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(S.of(context).verifyYourIdentity),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.of(context).useTheConfiguredBiometricFactorToAuthenticate)
                .paddedSymmetrically(horizontal: 16),
            const Icon(
              Icons.fingerprint,
              size: 96,
            ),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              runAlignment: WrapAlignment.spaceBetween,
              runSpacing: 8,
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () => _logout(context),
                  child: Text(
                    S.of(context).disconnect,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => context
                      .read<AuthenticationCubit>()
                      .restoreSessionState(context
                          .read<ApplicationSettingsCubit>()
                          .state
                          .isLocalAuthenticationEnabled),
                  child: Text(S.of(context).verifyIdentity),
                ),
              ],
            ).padded(16),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    context.read<AuthenticationCubit>().logout();
    context.read<LabelRepository<Tag>>().clear();
    context.read<LabelRepository<Correspondent>>().clear();
    context.read<LabelRepository<DocumentType>>().clear();
    context.read<LabelRepository<StoragePath>>().clear();
    context.read<SavedViewRepository>().clear();
    HydratedBloc.storage.clear();
  }
}
