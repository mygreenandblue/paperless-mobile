// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_settings_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationSettingsState _$ApplicationSettingsStateFromJson(
        Map<String, dynamic> json) =>
    ApplicationSettingsState(
      preferredLocaleSubtag: json['preferredLocaleSubtag'] as String,
      preferredThemeMode:
          $enumDecodeNullable(_$ThemeModeEnumMap, json['preferredThemeMode']) ??
              ThemeMode.system,
      isLocalAuthenticationEnabled:
          json['isLocalAuthenticationEnabled'] as bool? ?? false,
      preferredViewType:
          $enumDecodeNullable(_$ViewTypeEnumMap, json['preferredViewType']) ??
              ViewType.list,
      preferredColorSchemeOption: $enumDecodeNullable(
              _$ColorSchemeOptionEnumMap, json['preferredColorSchemeOption']) ??
          ColorSchemeOption.dynamic,
    );

Map<String, dynamic> _$ApplicationSettingsStateToJson(
        ApplicationSettingsState instance) =>
    <String, dynamic>{
      'isLocalAuthenticationEnabled': instance.isLocalAuthenticationEnabled,
      'preferredLocaleSubtag': instance.preferredLocaleSubtag,
      'preferredThemeMode': _$ThemeModeEnumMap[instance.preferredThemeMode]!,
      'preferredViewType': _$ViewTypeEnumMap[instance.preferredViewType]!,
      'preferredColorSchemeOption':
          _$ColorSchemeOptionEnumMap[instance.preferredColorSchemeOption]!,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

const _$ViewTypeEnumMap = {
  ViewType.grid: 'grid',
  ViewType.list: 'list',
};

const _$ColorSchemeOptionEnumMap = {
  ColorSchemeOption.classic: 'classic',
  ColorSchemeOption.dynamic: 'dynamic',
};
