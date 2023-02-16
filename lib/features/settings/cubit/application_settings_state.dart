part of 'application_settings_cubit.dart';

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
  final ColorSchemeOption preferredColorSchemeOption;

  ApplicationSettingsState({
    required this.preferredLocaleSubtag,
    this.preferredThemeMode = ThemeMode.system,
    this.isLocalAuthenticationEnabled = false,
    this.preferredColorSchemeOption = ColorSchemeOption.classic,
  });

  Map<String, dynamic> toJson() => _$ApplicationSettingsStateToJson(this);
  factory ApplicationSettingsState.fromJson(Map<String, dynamic> json) =>
      _$ApplicationSettingsStateFromJson(json);

  ApplicationSettingsState copyWith({
    bool? isLocalAuthenticationEnabled,
    String? preferredLocaleSubtag,
    ThemeMode? preferredThemeMode,
    ColorSchemeOption? preferredColorSchemeOption,
  }) {
    return ApplicationSettingsState(
      isLocalAuthenticationEnabled:
          isLocalAuthenticationEnabled ?? this.isLocalAuthenticationEnabled,
      preferredLocaleSubtag:
          preferredLocaleSubtag ?? this.preferredLocaleSubtag,
      preferredThemeMode: preferredThemeMode ?? this.preferredThemeMode,
      preferredColorSchemeOption:
          preferredColorSchemeOption ?? this.preferredColorSchemeOption,
    );
  }

  static String get _defaultPreferredLocaleSubtag {
    String preferredLocale = Platform.localeName.split("_").first;
    if (!S.supportedLocales
        .any((locale) => locale.languageCode == preferredLocale)) {
      preferredLocale = 'en';
    }
    return preferredLocale;
  }
}
