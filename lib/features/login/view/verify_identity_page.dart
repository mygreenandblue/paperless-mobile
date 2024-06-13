import 'package:flutter/material.dart';
import 'package:edocs_mobile/core/extensions/flutter_extensions.dart';
import 'package:edocs_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:edocs_mobile/routing/routes/shells/authenticated_route.dart';
import 'package:edocs_mobile/routing/routes/login_route.dart';
import 'package:provider/provider.dart';

class VerifyIdentityPage extends StatelessWidget {
  final String userId;
  const VerifyIdentityPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(S.of(context)!.verifyYourIdentity),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  const LoginToExistingAccountRoute().go(context);
                },
                child: Text(S.of(context)!.goToLogin),
              ),
              FilledButton(
                onPressed: () =>
                    context.read<AuthenticationCubit>().restoreSession(userId),
                child: Text(S.of(context)!.verifyIdentity),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              S.of(context)!.useTheConfiguredBiometricFactorToAuthenticate,
              textAlign: TextAlign.center,
            ).paddedSymmetrically(horizontal: 16),
            const Icon(
              Icons.fingerprint,
              size: 96,
            ),
            // Wrap(
            //   alignment: WrapAlignment.spaceBetween,
            //   runAlignment: WrapAlignment.spaceBetween,
            //   runSpacing: 8,
            //   spacing: 8,
            //   children: [

            //   ],
            // ).padded(16),
          ],
        ),
      ),
    );
  }
}
