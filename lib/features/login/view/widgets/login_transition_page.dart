import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:edocs_mobile/core/extensions/flutter_extensions.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:edocs_mobile/routing/routes/app_logs_route.dart';
import 'package:edocs_mobile/theme.dart';

class LoginTransitionPage extends StatelessWidget {
  final String text;
  const LoginTransitionPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: buildOverlayStyle(
          Theme.of(context),
          systemNavigationBarColor: Theme.of(context).colorScheme.background,
        ),
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(text).paddedOnly(bottom: 24),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  child: Text(S.of(context)!.appLogs('')),
                  onPressed: () {
                    AppLogsRoute().push(context);
                  },
                ),
              ),
            ],
          ).padded(16),
        ),
      ),
    );
  }
}
