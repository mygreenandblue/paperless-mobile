import 'package:edocs_mobile/features/settings/view/widgets/synchrounous_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/features/settings/view/widgets/app_logs_tile.dart';
import 'package:edocs_mobile/features/settings/view/widgets/biometric_authentication_setting.dart';
import 'package:edocs_mobile/features/settings/view/widgets/changelogs_tile.dart';
import 'package:edocs_mobile/features/settings/view/widgets/clear_storage_settings.dart';
import 'package:edocs_mobile/features/settings/view/widgets/color_scheme_option_setting.dart';
import 'package:edocs_mobile/features/settings/view/widgets/default_download_file_type_setting.dart';
import 'package:edocs_mobile/features/settings/view/widgets/default_share_file_type_setting.dart';
import 'package:edocs_mobile/features/settings/view/widgets/disable_animations_setting.dart';
import 'package:edocs_mobile/features/settings/view/widgets/enforce_pdf_upload_setting.dart';
import 'package:edocs_mobile/features/settings/view/widgets/language_selection_setting.dart';
import 'package:edocs_mobile/features/settings/view/widgets/skip_document_prepraration_on_share_setting.dart';
import 'package:edocs_mobile/features/settings/view/widgets/theme_mode_setting.dart';
import 'package:edocs_mobile/features/settings/view/widgets/user_settings_builder.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.settings),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, S.of(context)!.appearance),
          const LanguageSelectionSetting(),
          const ThemeModeSetting(),
          const ColorSchemeOptionSetting(),
          _buildSectionHeader(context, S.of(context)!.security),
          const BiometricAuthenticationSetting(),
          _buildSectionHeader(context, S.of(context)!.behavior),
          const DefaultDownloadFileTypeSetting(),
          const DefaultShareFileTypeSetting(),
          const EnforcePdfUploadSetting(),
          const SkipDocumentPreprationOnShareSetting(),
          const SynchronousSetting(),

          // _buildSectionHeader(context, S.of(context)!.storage),
          // const ClearCacheSetting(),
          // _buildSectionHeader(context, S.of(context)!.accessibility),
          // const DisableAnimationsSetting(),
          // _buildSectionHeader(context, S.of(context)!.misc),
          // const AppLogsTile(),
          // const ChangelogsTile(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
