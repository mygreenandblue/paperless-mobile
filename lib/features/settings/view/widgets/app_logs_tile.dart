import 'package:flutter/material.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routing/routes/app_logs_route.dart';

class AppLogsTile extends StatelessWidget {
  const AppLogsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.subject),
      title: Text(S.of(context)!.appLogs('')),
      onTap: () {
        AppLogsRoute().push(context);
      },
    );
  }
}
