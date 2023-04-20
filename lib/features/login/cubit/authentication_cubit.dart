import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/interceptor/dio_http_error_interceptor.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/repository/saved_view_repository.dart';
import 'package:paperless_mobile/core/security/session_manager.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/model/login_form_credentials.dart';
import 'package:paperless_mobile/features/login/model/user_account.dart';
import 'package:paperless_mobile/features/login/model/user_credentials.dart';
import 'package:paperless_mobile/features/login/services/authentication_service.dart';
import 'package:paperless_mobile/features/settings/model/global_settings.dart';
import 'package:paperless_mobile/features/settings/model/user_settings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final LocalAuthenticationService _localAuthService;
  final PaperlessAuthenticationApi _authApi;
  final SessionManager _dioWrapper;
  final LabelRepository _labelRepository;
  final SavedViewRepository _savedViewRepository;
  final PaperlessServerStatsApi _serverStatsApi;

  AuthenticationCubit(
    this._localAuthService,
    this._authApi,
    this._dioWrapper,
    this._labelRepository,
    this._savedViewRepository,
    this._serverStatsApi,
  ) : super(const AuthenticationState());

  Future<void> login({
    required LoginFormCredentials credentials,
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

    final userId = "${credentials.username}@$serverUrl";

    // If it is first time login, create settings for this user.
    final userSettingsBox = Hive.box<UserSettings>(HiveBoxes.userSettings);
    final userAccountBox = Hive.box<UserAccount>(HiveBoxes.userAccount);
    if (!userSettingsBox.containsKey(userId)) {
      userSettingsBox.put(userId, UserSettings());
    }
    final fullName = await _fetchFullName();

    if (!userAccountBox.containsKey(userId)) {
      userAccountBox.put(
        userId,
        UserAccount(
          serverUrl: serverUrl,
          username: credentials.username!,
          fullName: fullName,
        ),
      );
    }

    // Mark logged in user as currently active user.
    final globalSettings = GlobalSettings.boxedValue;
    globalSettings.currentLoggedInUser = userId;
    globalSettings.save();

    // Save credentials in encrypted box
    final userCredentialsBox = await _getUserCredentialsBox();
    await userCredentialsBox.put(
      userId,
      UserCredentials(
        token: token,
        clientCertificate: clientCertificate,
      ),
    );
    userCredentialsBox.close();
    emit(
      AuthenticationState(
        isAuthenticated: true,
        username: credentials.username,
        userId: userId,
        fullName: fullName,
        //TODO: Query ui settings with full name and add as parameter here...
      ),
    );
  }

  /// Switches to another account if it exists.
  Future<void> switchAccount(String userId) async {
    final globalSettings = GlobalSettings.boxedValue;
    if (globalSettings.currentLoggedInUser == userId) {
      return;
    }
    final userAccountBox = Hive.box<UserAccount>(HiveBoxes.userAccount);
    final userSettingsBox = Hive.box<UserSettings>(HiveBoxes.userSettings);

    if (!userSettingsBox.containsKey(userId)) {
      debugPrint("User $userId not yet registered.");
      return;
    }

    final userSettings = userSettingsBox.get(userId)!;
    final account = userAccountBox.get(userId)!;

    if (userSettings.isBiometricAuthenticationEnabled) {
      final authenticated =
          await _localAuthService.authenticateLocalUser("Authenticate to switch your account.");
      if (!authenticated) {
        debugPrint("User unable to authenticate.");
        return;
      }
    }

    final credentialsBox = await _getUserCredentialsBox();
    if (!credentialsBox.containsKey(userId)) {
      await credentialsBox.close();
      debugPrint("Invalid authentication for $userId");
      return;
    }

    final credentials = credentialsBox.get(userId);
    await _resetExternalState();

    _dioWrapper.updateSettings(
      authToken: credentials!.token,
      clientCertificate: credentials.clientCertificate,
      serverInformation: PaperlessServerInformationModel(),
      baseUrl: account.serverUrl,
    );

    globalSettings.currentLoggedInUser = userId;
    await globalSettings.save();
    await _reloadRepositories();
    emit(
      AuthenticationState(
        isAuthenticated: true,
        username: account.username,
        fullName: account.fullName,
        userId: userId,
      ),
    );
  }

  Future<String> addAccount({
    required LoginFormCredentials credentials,
    required String serverUrl,
    ClientCertificate? clientCertificate,
    required bool enableBiometricAuthentication,
  }) async {
    assert(credentials.password != null && credentials.username != null);
    final userId = "${credentials.username}@$serverUrl";
    final userAccountsBox = Hive.box<UserAccount>(HiveBoxes.userAccount);
    final userSettingsBox = Hive.box<UserSettings>(HiveBoxes.userSettings);

    if (userAccountsBox.containsKey(userId)) {
      throw Exception("User already exists");
    }
    // Creates a parallel session to get token and disposes of resources after.
    final sessionManager = SessionManager([
      DioHttpErrorInterceptor(),
    ]);
    sessionManager.updateSettings(
      clientCertificate: clientCertificate,
      baseUrl: serverUrl,
    );
    final authApi = PaperlessAuthenticationApiImpl(sessionManager.client);

    final token = await authApi.login(
      username: credentials.username!,
      password: credentials.password!,
    );
    sessionManager.resetSettings();
    await userSettingsBox.put(
      userId,
      UserSettings(
        isBiometricAuthenticationEnabled: enableBiometricAuthentication,
      ),
    );
    final fullName = await _fetchFullName();
    await userAccountsBox.put(
      userId,
      UserAccount(
        serverUrl: serverUrl,
        username: credentials.username!,
        fullName: fullName,
      ),
    );

    final userCredentialsBox = await _getUserCredentialsBox();
    await userCredentialsBox.put(
      userId,
      UserCredentials(
        token: token,
        clientCertificate: clientCertificate,
      ),
    );
    await userCredentialsBox.close();
    return userId;
  }

  Future<void> removeAccount(String userId) async {
    final globalSettings = GlobalSettings.boxedValue;
    final currentUser = globalSettings.currentLoggedInUser;
    final userAccountBox = Hive.box<UserAccount>(HiveBoxes.userAccount);
    final userCredentialsBox = await _getUserCredentialsBox();
    final userSettingsBox = Hive.box<UserSettings>(HiveBoxes.userSettings);

    await userAccountBox.delete(userId);
    await userCredentialsBox.delete(userId);
    await userSettingsBox.delete(userId);

    if (currentUser == userId) {
      return logout();
    }
  }

  ///
  /// Performs a conditional hydration based on the local authentication success.
  ///
  Future<void> restoreSessionState() async {
    final globalSettings = GlobalSettings.boxedValue;
    final userId = globalSettings.currentLoggedInUser;
    if (userId == null) {
      // If there is nothing to restore, we can quit here.
      return;
    }

    final userSettings = Hive.box<UserSettings>(HiveBoxes.userSettings).get(userId)!;
    final userAccount = Hive.box<UserAccount>(HiveBoxes.userAccount).get(userId)!;

    if (userSettings.isBiometricAuthenticationEnabled) {
      final localAuthSuccess =
          await _localAuthService.authenticateLocalUser("Authenticate to log back in"); //TODO: INTL
      if (!localAuthSuccess) {
        emit(const AuthenticationState(showBiometricAuthenticationScreen: true));
        return;
      }
    }
    final userCredentialsBox = await _getUserCredentialsBox();

    final authentication = userCredentialsBox.get(globalSettings.currentLoggedInUser!);
    if (authentication != null) {
      _dioWrapper.updateSettings(
        clientCertificate: authentication.clientCertificate,
        authToken: authentication.token,
        baseUrl: userAccount.serverUrl,
        serverInformation: PaperlessServerInformationModel(),
      );
      emit(
        AuthenticationState(
          isAuthenticated: true,
          showBiometricAuthenticationScreen: false,
          username: userAccount.username,
        ),
      );
    } else {
      throw Exception("User should be authenticated but no authentication information was found.");
    }
  }

  Future<void> logout() async {
    await _resetExternalState();
    final globalSettings = GlobalSettings.boxedValue;
    globalSettings
      ..currentLoggedInUser = null
      ..save();
    emit(const AuthenticationState());
  }

  Future<Uint8List> _getEncryptedBoxKey() async {
    const secureStorage = FlutterSecureStorage();
    if (!await secureStorage.containsKey(key: 'key')) {
      final key = Hive.generateSecureKey();

      await secureStorage.write(
        key: 'key',
        value: base64UrlEncode(key),
      );
    }
    final key = (await secureStorage.read(key: 'key'))!;
    return base64Decode(key);
  }

  Future<Box<UserCredentials>> _getUserCredentialsBox() async {
    final keyBytes = await _getEncryptedBoxKey();
    return Hive.openBox<UserCredentials>(
      HiveBoxes.userCredentials,
      encryptionCipher: HiveAesCipher(keyBytes),
    );
  }

  Future<void> _resetExternalState() {
    _dioWrapper.resetSettings();
    return Future.wait([
      HydratedBloc.storage.clear(),
      _labelRepository.clear(),
      _savedViewRepository.clear(),
    ]);
  }

  Future<void> _reloadRepositories() {
    return Future.wait([
      _labelRepository.initialize(),
      _savedViewRepository.findAll(),
    ]);
  }

  Future<String?> _fetchFullName() async {
    try {
      final uiSettings = await _serverStatsApi.getUiSettings();
      return uiSettings.displayName;
    } catch (error) {
      return null;
    }
  }
}
