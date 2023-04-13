import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/security/session_manager.dart';
import 'package:paperless_mobile/features/login/model/authentication_information.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/model/user_credentials.model.dart';
import 'package:paperless_mobile/features/login/services/authentication_service.dart';
import 'package:paperless_mobile/features/settings/global_app_settings.dart';
import 'package:paperless_mobile/features/settings/user_app_settings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final LocalAuthenticationService _localAuthService;
  final PaperlessAuthenticationApi _authApi;
  final SessionManager _dioWrapper;

  AuthenticationCubit(
    this._localAuthService,
    this._authApi,
    this._dioWrapper,
  ) : super(AuthenticationState.initial);

  Future<void> login({
    required UserCredentials credentials,
    required String serverUrl,
    ClientCertificate? clientCertificate,
  }) async {
    assert(credentials.username != null && credentials.password != null);

    _dioWrapper.updateSettings(
      baseUrl: serverUrl,
      clientCertificate: clientCertificate,
    );
    final token = await _authApi.login(
      username: credentials.username!,
      password: credentials.password!,
    );
    _dioWrapper.updateSettings(
      baseUrl: serverUrl,
      clientCertificate: clientCertificate,
      authToken: token,
    );
    final authInfo = AuthenticationInformation(
      username: credentials.username!,
      serverUrl: serverUrl,
      clientCertificate: clientCertificate,
      token: token,
    );
    final userId = "${credentials.username}@$serverUrl";

    // Mark logged in user as currently active user.
    final globalSettings = GlobalAppSettings.boxedValue;
    globalSettings.currentLoggedInUser = userId;
    await globalSettings.save();

    // Save credentials in encrypted box
    final encryptedBox = await _openEncryptedBox();
    await encryptedBox.put(
      userId,
      authInfo,
    );
    encryptedBox.close();

    emit(
      AuthenticationState(
        wasLoginStored: false,
        authentication: authInfo,
      ),
    );
  }

  ///
  /// Performs a conditional hydration based on the local authentication success.
  ///
  Future<void> restoreSessionState() async {
    final globalSettings = GlobalAppSettings.boxedValue;
    if (globalSettings.currentLoggedInUser == null) {
      // If there is nothing to restore, we can quit here.
      return;
    }

    final userSettings = Hive.box<UserAppSettings>(HiveBoxes.userSettings)
        .get(globalSettings.currentLoggedInUser!);

    if (userSettings!.isBiometricAuthenticationEnabled) {
      final localAuthSuccess = await _localAuthService
          .authenticateLocalUser("Authenticate to log back in"); //TODO: INTL
      if (localAuthSuccess) {
        final authentication = await _readAuthenticationFromEncryptedBox(
            globalSettings.currentLoggedInUser!);
        if (authentication != null) {
          _dioWrapper.updateSettings(
            clientCertificate: authentication.clientCertificate,
            authToken: authentication.token,
            baseUrl: authentication.serverUrl,
          );
          return emit(
            AuthenticationState(
              wasLoginStored: true,
              authentication: state.authentication,
              wasLocalAuthenticationSuccessful: true,
            ),
          );
        }
      } else {
        return emit(
          AuthenticationState(
            wasLoginStored: true,
            wasLocalAuthenticationSuccessful: false,
            authentication: null,
          ),
        );
      }
    } else {
      final authentication = await _readAuthenticationFromEncryptedBox(
          globalSettings.currentLoggedInUser!);
      if (authentication != null) {
        _dioWrapper.updateSettings(
          clientCertificate: authentication.clientCertificate,
          authToken: authentication.token,
          baseUrl: authentication.serverUrl,
        );
        emit(
          AuthenticationState(
            authentication: authentication,
            wasLoginStored: true,
          ),
        );
      } else {
        return emit(AuthenticationState.initial);
      }
    }
  }

  Future<AuthenticationInformation?> _readAuthenticationFromEncryptedBox(
      String userId) {
    return _openEncryptedBox().then((box) => box.get(userId));
  }

  Future<Box<AuthenticationInformation?>> _openEncryptedBox() async {
    const secureStorage = FlutterSecureStorage();
    final encryptionKeyString = await secureStorage.read(key: 'key');
    if (encryptionKeyString == null) {
      final key = Hive.generateSecureKey();

      await secureStorage.write(
        key: 'key',
        value: base64UrlEncode(key),
      );
    }
    final key = await secureStorage.read(key: 'key');
    final encryptionKeyUint8List = base64Url.decode(key!);
    return await Hive.openBox<AuthenticationInformation>(
      HiveBoxes.vault,
      encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
    );
  }

  Future<void> logout() async {
    await Hive.box<AuthenticationInformation>(HiveBoxes.authentication).clear();
    _dioWrapper.resetSettings();
    emit(AuthenticationState.initial);
  }
}
