import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_mobile/features/login/services/authentication_service.dart';
import 'package:paperless_mobile/features/settings/model/color_scheme_option.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

part 'application_settings_cubit.g.dart';
part 'application_settings_state.dart';

class ApplicationSettingsCubit extends HydratedCubit<ApplicationSettingsState> {
  final LocalAuthenticationService _localAuthenticationService;
  ApplicationSettingsCubit(this._localAuthenticationService)
      : super(ApplicationSettingsState.defaultSettings);

  Future<void> setLocale(String? localeSubtag) async {
    final updatedSettings = state.copyWith(preferredLocaleSubtag: localeSubtag);
    _updateSettings(updatedSettings);
  }

  Future<void> setIsBiometricAuthenticationEnabled(
    bool isEnabled, {
    required String localizedReason,
  }) async {
    final isActionAuthorized = await _localAuthenticationService
        .authenticateLocalUser(localizedReason);
    if (isActionAuthorized) {
      final updatedSettings =
          state.copyWith(isLocalAuthenticationEnabled: isEnabled);
      _updateSettings(updatedSettings);
    }
  }

  void setThemeMode(ThemeMode? selectedMode) {
    final updatedSettings = state.copyWith(preferredThemeMode: selectedMode);
    _updateSettings(updatedSettings);
  }

  void setColorSchemeOption(ColorSchemeOption schemeOption) {
    final updatedSettings =
        state.copyWith(preferredColorSchemeOption: schemeOption);
    _updateSettings(updatedSettings);
  }

  void _updateSettings(ApplicationSettingsState settings) async {
    emit(settings);
  }

  @override
  Future<void> clear() async {
    await super.clear();
    emit(ApplicationSettingsState.defaultSettings);
  }

  @override
  ApplicationSettingsState? fromJson(Map<String, dynamic> json) =>
      ApplicationSettingsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ApplicationSettingsState state) =>
      state.toJson();
}
