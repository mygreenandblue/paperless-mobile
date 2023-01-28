import 'dart:io';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_mobile/features/settings/model/color_scheme_option.dart';
import 'package:paperless_mobile/features/settings/model/view_type.dart';
import 'package:paperless_mobile/generated/l10n.dart';

part 'application_settings_state.g.dart';

///
/// State holding the current application settings such as selected language, theme mode and more.
///
@JsonSerializable()
class ApplicationSettingsState {
  static final defaultSettings = ApplicationSettingsState(
    preferredLocaleSubtag: _defaultPreferredLocaleSubtag,
  );

  final bool isLocalAuthenticationEnabled;
  final String preferredLocaleSubtag;
  final ThemeMode preferredThemeMode;
  final ViewType preferredViewType;
  final ColorSchemeOption preferredColorSchemeOption;

  ApplicationSettingsState({
    required this.preferredLocaleSubtag,
    this.preferredThemeMode = ThemeMode.system,
    this.isLocalAuthenticationEnabled = false,
    this.preferredViewType = ViewType.list,
    this.preferredColorSchemeOption = ColorSchemeOption.dynamic,
  });

  Map<String, dynamic> toJson() => _$ApplicationSettingsStateToJson(this);
  factory ApplicationSettingsState.fromJson(Map<String, dynamic> json) =>
      _$ApplicationSettingsStateFromJson(json);

  ApplicationSettingsState copyWith({
    bool? isLocalAuthenticationEnabled,
    String? preferredLocaleSubtag,
    ThemeMode? preferredThemeMode,
    ViewType? preferredViewType,
    ColorSchemeOption? preferredColorSchemeOption,
  }) {
    return ApplicationSettingsState(
      isLocalAuthenticationEnabled:
          isLocalAuthenticationEnabled ?? this.isLocalAuthenticationEnabled,
      preferredLocaleSubtag:
          preferredLocaleSubtag ?? this.preferredLocaleSubtag,
      preferredThemeMode: preferredThemeMode ?? this.preferredThemeMode,
      preferredViewType: preferredViewType ?? this.preferredViewType,
      preferredColorSchemeOption:
          preferredColorSchemeOption ?? this.preferredColorSchemeOption,
    );
  }

  static String get _defaultPreferredLocaleSubtag {
    String preferredLocale = Platform.localeName.split("_").first;
    if (!S.delegate.supportedLocales
        .any((locale) => locale.languageCode == preferredLocale)) {
      preferredLocale = 'en';
    }
    return preferredLocale;
  }
}
