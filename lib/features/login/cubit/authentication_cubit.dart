import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/config/hive/hive_extensions.dart';
import 'package:paperless_mobile/core/database/tables/global_settings.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/database/tables/local_user_app_state.dart';
import 'package:paperless_mobile/core/database/tables/local_user_settings.dart';
import 'package:paperless_mobile/core/database/tables/user_credentials.dart';
import 'package:paperless_mobile/core/factory/paperless_api_factory.dart';
import 'package:paperless_mobile/core/interceptor/language_header.interceptor.dart';
import 'package:paperless_mobile/core/logging/logger.dart';
import 'package:paperless_mobile/core/model/info_message_exception.dart';
import 'package:paperless_mobile/core/security/session_manager.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/core/service/file_service.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/model/login_form_credentials.dart';
import 'package:paperless_mobile/features/login/model/reachability_status.dart';
import 'package:paperless_mobile/features/login/services/authentication_service.dart';
import 'package:paperless_mobile/features/notifications/services/local_notification_service.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

part 'authentication_state.dart';

typedef _FutureVoidCallback = Future<void> Function();

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final LocalAuthenticationService _localAuthService;
  final PaperlessApiFactory _apiFactory;
  final SessionManager _sessionManager;
  final ConnectivityStatusService _connectivityService;
  final LocalNotificationService _notificationService;

  AuthenticationCubit(
    this._localAuthService,
    this._apiFactory,
    this._sessionManager,
    this._connectivityService,
    this._notificationService,
  ) : super(const UnauthenticatedState());

  Future<void> login({
    required LoginFormCredentials credentials,
    required String serverUrl,
    ClientCertificate? clientCertificate,
  }) async {
    assert(credentials.username != null && credentials.password != null);
    if (state is AuthenticatingState) {
      // Cancel duplicate login requests
      return;
    }
    emit(const AuthenticatingState(AuthenticatingStage.authenticating));
    final localUserId = "${credentials.username}@$serverUrl";
    logger.t("AuthenticationCubit#login(): Trying to log in $localUserId...");
    try {
      await _addUser(
        localUserId,
        serverUrl,
        credentials,
        clientCertificate,
        _sessionManager,
        onFetchUserInformation: () async {
          emit(const AuthenticatingState(
              AuthenticatingStage.fetchingUserInformation));
        },
        onPerformLogin: () async {
          emit(const AuthenticatingState(AuthenticatingStage.authenticating));
        },
        onPersistLocalUserData: () async {
          emit(const AuthenticatingState(
              AuthenticatingStage.persistingLocalUserData));
        },
      );
    } catch (e) {
      emit(
        AuthenticationErrorState(
          serverUrl: serverUrl,
          username: credentials.username!,
          password: credentials.password!,
          clientCertificate: clientCertificate,
        ),
      );
      rethrow;
    }

    // Mark logged in user as currently active user.
    final globalSettings =
        Hive.box<GlobalSettings>(HiveBoxes.globalSettings).getValue()!;
    globalSettings.loggedInUserId = localUserId;
    await globalSettings.save();

    emit(AuthenticatedState(localUserId: localUserId));
    logger.t(
        'AuthenticationCubit#login(): User $localUserId successfully logged in.');
  }

  /// Switches to another account if it exists.
  Future<void> switchAccount(String localUserId) async {
    emit(const SwitchingAccountsState());
    logger.t(
        'AuthenticationCubit#switchAccount(): Trying to switch to user $localUserId...');

    final globalSettings =
        Hive.box<GlobalSettings>(HiveBoxes.globalSettings).getValue()!;

    final userAccountBox = Hive.localUserAccountBox;

    if (!userAccountBox.containsKey(localUserId)) {
      logger.w(
        'AuthenticationCubit#switchAccount(): User $localUserId not yet registered. '
        'This should never be the case!',
      );
      return;
    }

    final account = userAccountBox.get(localUserId)!;

    if (account.settings.isBiometricAuthenticationEnabled) {
      final authenticated = await _localAuthService
          .authenticateLocalUser("Authenticate to switch your account.");
      if (!authenticated) {
        logger.w(
            "AuthenticationCubit#switchAccount(): User could not be authenticated.");
        emit(VerifyIdentityState(userId: localUserId));
        return;
      }
    }
    final currentlyLoggedInUser = globalSettings.loggedInUserId;
    if (currentlyLoggedInUser != localUserId) {
      await _notificationService.cancelUserNotifications(localUserId);
    }
    await withEncryptedBox<UserCredentials, void>(
        HiveBoxes.localUserCredentials, (credentialsBox) async {
      if (!credentialsBox.containsKey(localUserId)) {
        await credentialsBox.close();
        logger.w(
            "AuthenticationCubit#switchAccount(): Invalid authentication for $localUserId.");
        return;
      }
      final credentials = credentialsBox.get(localUserId);
      await _resetExternalState();

      _sessionManager.updateSettings(
        authToken: credentials!.token,
        clientCertificate: credentials.clientCertificate,
        baseUrl: account.serverUrl,
      );

      globalSettings.loggedInUserId = localUserId;
      await globalSettings.save();

      final apiVersion = await _getApiVersion(_sessionManager.client);

      await _updateRemoteUser(
        _sessionManager,
        Hive.box<LocalUserAccount>(HiveBoxes.localUserAccount)
            .get(localUserId)!,
        apiVersion,
      );

      emit(AuthenticatedState(localUserId: localUserId));
    });
  }

  Future<String> addAccount({
    required LoginFormCredentials credentials,
    required String serverUrl,
    ClientCertificate? clientCertificate,
    required bool enableBiometricAuthentication,
    required String locale,
  }) async {
    assert(credentials.password != null && credentials.username != null);
    final localUserId = "${credentials.username}@$serverUrl";
    logger
        .d("AuthenticationCubit#addAccount(): Adding account $localUserId...");

    final sessionManager = SessionManager([
      LanguageHeaderInterceptor(locale),
    ]);
    await _addUser(
      localUserId,
      serverUrl,
      credentials,
      clientCertificate,
      sessionManager,
    );

    return localUserId;
  }

  Future<void> removeAccount(String userId) async {
    logger
        .t("AuthenticationCubit#removeAccount(): Removing account $userId...");
    final userAccountBox = Hive.localUserAccountBox;
    final userAppStateBox = Hive.localUserAppStateBox;

    await FileService.clearUserData(userId: userId);
    await userAccountBox.delete(userId);
    await userAppStateBox.delete(userId);
    await withEncryptedBox<UserCredentials, void>(
        HiveBoxes.localUserCredentials, (box) {
      box.delete(userId);
    });
  }

  ///
  /// Restores the previous session if exists.
  ///
  Future<void> restoreSession([String? userId]) async {
    emit(const RestoringSessionState());
    logger.t(
        "AuthenticationCubit#restoreSessionState(): Trying to restore previous session...");
    final globalSettings =
        Hive.box<GlobalSettings>(HiveBoxes.globalSettings).getValue()!;
    final restoreSessionForUser = userId ?? globalSettings.loggedInUserId;
    // final localUserId = globalSettings.loggedInUserId;
    if (restoreSessionForUser == null) {
      logger.t(
          "AuthenticationCubit#restoreSessionState(): There is nothing to restore.");
      final otherAccountsExist = Hive.localUserAccountBox.isNotEmpty;
      // If there is nothing to restore, we can quit here.
      emit(
        UnauthenticatedState(redirectToAccountSelection: otherAccountsExist),
      );
      return;
    }
    final localUserAccountBox =
        Hive.box<LocalUserAccount>(HiveBoxes.localUserAccount);
    final localUserAccount = localUserAccountBox.get(restoreSessionForUser)!;
    if (localUserAccount.settings.isBiometricAuthenticationEnabled) {
      logger.t(
          "AuthenticationCubit#restoreSessionState(): Verifying user identity...");
      final authenticationMesage =
          (await S.delegate.load(Locale(globalSettings.preferredLocaleSubtag)))
              .verifyYourIdentity;
      final localAuthSuccess =
          await _localAuthService.authenticateLocalUser(authenticationMesage);
      if (!localAuthSuccess) {
        logger.w(
            "AuthenticationCubit#restoreSessionState(): Identity could not be verified.");
        emit(VerifyIdentityState(userId: restoreSessionForUser));
        return;
      }
      logger.t(
          "AuthenticationCubit#restoreSessionState(): Identity successfully verified.");
    }
    logger.t(
        "AuthenticationCubit#restoreSessionState(): Reading encrypted credentials...");
    final authentication =
        await withEncryptedBox<UserCredentials, UserCredentials>(
            HiveBoxes.localUserCredentials, (box) {
      return box.get(restoreSessionForUser);
    });

    if (authentication == null) {
      logger.e(
          "AuthenticationCubit#restoreSessionState(): Credentials could not be read!");
      throw Exception(
        "User should be authenticated but no authentication information was found.",
      );
    }
    logger.t(
        "AuthenticationCubit#restoreSessionState(): Credentials successfully retrieved.");

    logger.t(
        "AuthenticationCubit#restoreSessionState(): Updating security context...");

    _sessionManager.updateSettings(
      clientCertificate: authentication.clientCertificate,
      authToken: authentication.token,
      baseUrl: localUserAccount.serverUrl,
    );
    logger.t(
        "AuthenticationCubit#restoreSessionState(): Security context successfully updated.");
    final isPaperlessServerReachable =
        await _connectivityService.isPaperlessServerReachable(
              localUserAccount.serverUrl,
              authentication.clientCertificate,
            ) ==
            ReachabilityStatus.reachable;
    logger.t(
        "AuthenticationCubit#restoreSessionState(): Trying to update remote paperless user...");
    if (isPaperlessServerReachable) {
      final apiVersion = await _getApiVersion(_sessionManager.client);
      await _updateRemoteUser(
        _sessionManager,
        localUserAccount,
        apiVersion,
      );
      logger.t(
          "AuthenticationCubit#restoreSessionState(): Successfully updated remote paperless user.");
    } else {
      logger.w(
          "AuthenticationCubit#restoreSessionState(): Could not update remote paperless user. Server could not be reached. The app might behave unexpected!");
    }
    globalSettings.loggedInUserId = restoreSessionForUser;
    await globalSettings.save();
    emit(AuthenticatedState(localUserId: restoreSessionForUser));

    logger.t(
        "AuthenticationCubit#restoreSessionState(): Previous session successfully restored.");
  }

  Future<void> logout([bool removeAccount = false]) async {
    emit(const LoggingOutState());
    final globalSettings = Hive.globalSettingsBox.getValue()!;
    final userId = globalSettings.loggedInUserId!;
    logger.t(
        "AuthenticationCubit#logout(): Logging out current user ($userId)...");

    await _resetExternalState();
    await _notificationService.cancelUserNotifications(userId);

    final otherAccountsExist = Hive.localUserAccountBox.length > 1;
    emit(UnauthenticatedState(redirectToAccountSelection: otherAccountsExist));
    if (removeAccount) {
      await this.removeAccount(userId);
    }
    globalSettings.loggedInUserId = null;
    await globalSettings.save();

    logger.t("AuthenticationCubit#logout(): User successfully logged out.");
  }

  Future<void> _resetExternalState() async {
    logger.t(
        "AuthenticationCubit#_resetExternalState(): Resetting security context...");
    _sessionManager.resetSettings();
    logger.t(
        "AuthenticationCubit#_resetExternalState(): Security context reset.");
    logger.t(
        "AuthenticationCubit#_resetExternalState(): Clearing local state...");
    await HydratedBloc.storage.clear();
    logger.t("AuthenticationCubit#_resetExternalState(): Local state cleard.");
  }

  Future<int> _addUser(
    String localUserId,
    String serverUrl,
    LoginFormCredentials credentials,
    ClientCertificate? clientCert,
    SessionManager sessionManager, {
    _FutureVoidCallback? onPerformLogin,
    _FutureVoidCallback? onPersistLocalUserData,
    _FutureVoidCallback? onFetchUserInformation,
  }) async {
    assert(credentials.username != null && credentials.password != null);
    logger
        .t("AuthenticationCubit#_addUser(): Adding new user $localUserId....");

    sessionManager.updateSettings(
      baseUrl: serverUrl,
      clientCertificate: clientCert,
    );

    final authApi = _apiFactory.createAuthenticationApi(sessionManager.client);

    logger.t(
        "AuthenticationCubit#_addUser(): Fetching bearer token from the server...");

    await onPerformLogin?.call();

    final token = await authApi.login(
      username: credentials.username!,
      password: credentials.password!,
    );

    logger.t(
        "AuthenticationCubit#_addUser(): Bearer token successfully retrieved.");

    sessionManager.updateSettings(
      baseUrl: serverUrl,
      clientCertificate: clientCert,
      authToken: token,
    );

    final userAccountBox =
        Hive.box<LocalUserAccount>(HiveBoxes.localUserAccount);
    final userStateBox =
        Hive.box<LocalUserAppState>(HiveBoxes.localUserAppState);

    if (userAccountBox.containsKey(localUserId)) {
      logger.w(
          "AuthenticationCubit#_addUser(): The user $localUserId already exists.");
      throw InfoMessageException(code: ErrorCode.userAlreadyExists);
    }
    await onFetchUserInformation?.call();
    final apiVersion = await _getApiVersion(sessionManager.client);
    logger.t(
        "AuthenticationCubit#_addUser(): Trying to fetch remote paperless user for $localUserId.");

    late UserModel serverUser;
    try {
      serverUser = await _apiFactory
          .createUserApi(
            sessionManager.client,
            apiVersion: apiVersion,
          )
          .findCurrentUser();
    } on DioException catch (error, stackTrace) {
      logger.e(
        "AuthenticationCubit#_addUser(): An error occurred while fetching the remote paperless user.",
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
    logger.t(
        "AuthenticationCubit#_addUser(): Remote paperless user successfully fetched.");

    logger.t(
        "AuthenticationCubit#_addUser(): Persisting user account information...");

    await onPersistLocalUserData?.call();
    // Create user account
    await userAccountBox.put(
      localUserId,
      LocalUserAccount(
        id: localUserId,
        settings: LocalUserSettings(),
        serverUrl: serverUrl,
        paperlessUser: serverUser,
        apiVersion: apiVersion,
      ),
    );
    logger.t(
        "AuthenticationCubit#_addUser(): User account information successfully persisted.");
    logger.t("AuthenticationCubit#_addUser(): Persisting user app state...");
    // Create user state
    await userStateBox.put(
      localUserId,
      LocalUserAppState(userId: localUserId),
    );
    logger.t(
        "AuthenticationCubit#_addUser(): User state successfully persisted.");
    // Save credentials in encrypted box
    await withEncryptedBox(HiveBoxes.localUserCredentials, (box) async {
      logger.t(
          "AuthenticationCubit#_addUser(): Saving user credentials inside encrypted storage...");

      await box.put(
        localUserId,
        UserCredentials(
          token: token,
          clientCertificate: clientCert,
        ),
      );
      logger.t(
          "AuthenticationCubit#_addUser(): User credentials successfully saved.");
    });
    final hostsBox = Hive.box<String>(HiveBoxes.hosts);
    if (!hostsBox.values.contains(serverUrl)) {
      await hostsBox.add(serverUrl);
    }

    return serverUser.id;
  }

  Future<int> _getApiVersion(
    Dio dio, {
    Duration? timeout,
    int defaultValue = 2,
  }) async {
    logger.t(
        "AuthenticationCubit#_getApiVersion(): Trying to fetch API version...");
    try {
      final response = await dio.get(
        "/api/",
        options: Options(
          sendTimeout: timeout,
        ),
      );
      final apiVersion =
          int.parse(response.headers.value('x-api-version') ?? "3");
      logger.t(
          "AuthenticationCubit#_getApiVersion(): Successfully retrieved API version ($apiVersion).");

      return apiVersion;
    } on DioException catch (_) {
      logger.w(
          "AuthenticationCubit#_getApiVersion(): Could not retrieve API version.");
      return defaultValue;
    }
  }

  /// Fetches possibly updated (permissions, name, updated server version and thus new user model, ...) remote user data.
  Future<void> _updateRemoteUser(
    SessionManager sessionManager,
    LocalUserAccount localUserAccount,
    int apiVersion,
  ) async {
    logger.t(
        "AuthenticationCubit#_updateRemoteUser(): Trying to update remote user object...");
    final updatedPaperlessUser = await _apiFactory
        .createUserApi(
          sessionManager.client,
          apiVersion: apiVersion,
        )
        .findCurrentUser();

    localUserAccount.paperlessUser = updatedPaperlessUser;
    await localUserAccount.save();
    logger.t(
        "AuthenticationCubit#_updateRemoteUser(): Successfully updated remote user object.");
  }
}
