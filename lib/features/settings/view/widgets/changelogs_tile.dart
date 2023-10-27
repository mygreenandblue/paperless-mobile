import 'package:flutter/material.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routing/routes/changelog_route.dart';

class ChangelogsTile extends StatelessWidget {
  const ChangelogsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(S.of(context)!.changelog),
      onTap: () {
        ChangelogRoute().push(context);
      },
    );
  }
}
