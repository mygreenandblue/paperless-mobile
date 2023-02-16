import 'package:flutter/material.dart';
import 'package:paperless_mobile/features/settings/view/widgets/clear_storage_settings.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class StorageSettingsPage extends StatelessWidget {
  const StorageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.storage),
      ),
      body: ListView(
        children: const [
          ClearCacheSetting(),
        ],
      ),
    );
  }
}
