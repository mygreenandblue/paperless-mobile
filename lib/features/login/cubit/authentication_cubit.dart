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
    _debugPrintMessage(
      "login",
      "Trying to login $localUserId...",
    );
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
    _debugPrintMessage(
      "login",
      "User successfully logged in.",
    );
  }

  /// Switches to another account if it exists.
  Future<void> switchAccount(String localUserId) async {
    emit(const SwitchingAccountsState());
    _debugPrintMessage(
      "switchAccount",
      "Trying to switch to user $localUserId...",
    );

    final globalSettings =
        Hive.box<GlobalSettings>(HiveBoxes.globalSettings).getValue()!;
    // if (globalSettings.loggedInUserId == localUserId) {
    //   _debugPrintMessage(
    //     "switchAccount",
    //     "User $localUserId is already logged in.",
    //   );
    //   emit(AuthenticatedState(localUserId: localUserId));
    //   return;
    // }

    final userAccountBox = Hive.localUserAccountBox;

    if (!userAccountBox.containsKey(localUserId)) {
      debugPrint("User $localUserId not yet registered.");
      return;
    }

    final account = userAccountBox.get(localUserId)!;

    if (account.settings.isBiometricAuthenticationEnabled) {
      final authenticated = await _localAuthService
          .authenticateLocalUser("Authenticate to switch your account.");
      if (!authenticated) {
        _debugPrintMessage(
          "switchAccount",
          "User could not be authenticated.",
        );
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
        debugPrint("Invalid authentication for $localUserId");
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

    final sessionManager = SessionManager([
      LanguageHeaderInterceptor(locale),
    ]);
    try {
      await _addUser(
        localUserId,
        serverUrl,
        credentials,
        clientCertificate,
        sessionManager,
        // onPerformLogin: () async {
        //   emit(AuthenticatingState(AuthenticatingStage.authenticating));
        //   await Future.delayed(const Duration(milliseconds: 500));
        // },
      );

      return localUserId;
    } catch (error, stackTrace) {
      print(error);
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> removeAccount(String userId) async {
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
    _debugPrintMessage(
      "restoreSessionState",
      "Trying to restore previous session...",
    );
    final globalSettings =
        Hive.box<GlobalSettings>(HiveBoxes.globalSettings).getValue()!;
    final restoreSessionForUser = userId ?? globalSettings.loggedInUserId;
    // final localUserId = globalSettings.loggedInUserId;
    if (restoreSessionForUser == null) {
      _debugPrintMessage(
        "restoreSessionState",
        "There is nothing to restore.",
      );
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
    _debugPrintMessage(
      "restoreSessionState",
      "Checking if biometric authentication is required...",
    );
    if (localUserAccount.settings.isBiometricAuthenticationEnabled) {
      _debugPrintMessage(
        "restoreSessionState",
        "Biometric authentication required, waiting for user to authenticate...",
      );
      final authenticationMesage =
          (await S.delegate.load(Locale(globalSettings.preferredLocaleSubtag)))
              .verifyYourIdentity;
      final localAuthSuccess =
          await _localAuthService.authenticateLocalUser(authenticationMesage);
      if (!localAuthSuccess) {
        emit(VerifyIdentityState(userId: restoreSessionForUser));
        _debugPrintMessage(
          "restoreSessionState",
          "User could not be authenticated.",
        );
        return;
      }
      _debugPrintMessage(
        "restoreSessionState",
        "User successfully autheticated.",
      );
    } else {
      _debugPrintMessage(
        "restoreSessionState",
        "Biometric authentication not configured, skipping.",
      );
    }
    _debugPrintMessage(
      "restoreSessionState",
      "Trying to retrieve authentication credentials...",
    );
    final authentication =
        await withEncryptedBox<UserCredentials, UserCredentials>(
            HiveBoxes.localUserCredentials, (box) {
      return box.get(restoreSessionForUser);
    });

    if (authentication == null) {
      _debugPrintMessage(
        "restoreSessionState",
        "Could not retrieve existing authentication credentials.",
      );
      throw Exception(
        "User should be authenticated but no authentication information was found.",
      );
    }

    _debugPrintMessage(
      "restoreSessionState",
      "Authentication credentials successfully retrieved.",
    );

    _debugPrintMessage(
      "restoreSessionState",
      "Updating current session state...",
    );

    _sessionManager.updateSettings(
      clientCertificate: authentication.clientCertificate,
      authToken: authentication.token,
      baseUrl: localUserAccount.serverUrl,
    );
    _debugPrintMessage(
      "restoreSessionState",
      "Current session state successfully updated.",
    );
    final isPaperlessServerReachable =
        await _connectivityService.isPaperlessServerReachable(
              localUserAccount.serverUrl,
              authentication.clientCertificate,
            ) ==
            ReachabilityStatus.reachable;
    if (isPaperlessServerReachable) {
      _debugPrintMessage(
        "restoreSessionMState",
        "Updating server user...",
      );
      final apiVersion = await _getApiVersion(_sessionManager.client);
      await _updateRemoteUser(
        _sessionManager,
        localUserAccount,
        apiVersion,
      );
      _debugPrintMessage(
        "restoreSessionMState",
        "Successfully updated server user.",
      );
    } else {
      _debugPrintMessage(
        "restoreSessionMState",
        "Skipping update of server user (server could not be reached).",
      );
    }
    globalSettings.loggedInUserId = restoreSessionForUser;
    await globalSettings.save();
    emit(AuthenticatedState(localUserId: restoreSessionForUser));

    _debugPrintMessage(
      "restoreSessionState",
      "Session was successfully restored.",
    );
  }

  Future<void> logout([bool removeAccount = false]) async {
    emit(const LoggingOutState());
    _debugPrintMessage(
      "logout",
      "Trying to log out current user...",
    );
    await _resetExternalState();
    final globalSettings = Hive.globalSettingsBox.getValue()!;
    final userId = globalSettings.loggedInUserId!;
    await _notificationService.cancelUserNotifications(userId);

    final otherAccountsExist = Hive.localUserAccountBox.length > 1;
    emit(UnauthenticatedState(redirectToAccountSelection: otherAccountsExist));
    if (removeAccount) {
      await this.removeAccount(userId);
    }
    globalSettings.loggedInUserId = null;
    await globalSettings.save();

    _debugPrintMessage(
      "logout",
      "User successfully logged out.",
    );
  }

  Future<void> _resetExternalState() async {
    _sessionManager.resetSettings();
    await HydratedBloc.storage.clear();
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
    _debugPrintMessage("_addUser", "Adding new user $localUserId...");

    sessionManager.updateSettings(
      baseUrl: serverUrl,
      clientCertificate: clientCert,
    );

    final authApi = _apiFactory.createAuthenticationApi(sessionManager.client);

    _debugPrintMessage(
      "_addUser",
      "Trying to login user ${credentials.username} on $serverUrl...",
    );

    await onPerformLogin?.call();

    final token = await authApi.login(
      username: credentials.username!,
      password: credentials.password!,
    );

    _debugPrintMessage(
      "_addUser",
      "Successfully acquired token.",
    );

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
      _debugPrintMessage(
        "_addUser",
        "An error occurred! The user $localUserId already exists.",
      );
      throw InfoMessageException(code: ErrorCode.userAlreadyExists);
    }
    await onFetchUserInformation?.call();
    final apiVersion = await _getApiVersion(sessionManager.client);
    _debugPrintMessage(
      "_addUser",
      "Trying to fetch user object for $localUserId...",
    );
    late UserModel serverUser;
    try {
      serverUser = await _apiFactory
          .createUserApi(
            sessionManager.client,
            apiVersion: apiVersion,
          )
          .findCurrentUser();
    } on DioException catch (error, stackTrace) {
      _debugPrintMessage(
        "_addUser",
        "An error occurred: ${error.message}",
        stackTrace: stackTrace,
      );
      rethrow;
    }
    _debugPrintMessage(
      "_addUser",
      "User object successfully fetched.",
    );
    _debugPrintMessage(
      "_addUser",
      "Persisting local user account...",
    );
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
    _debugPrintMessage(
      "_addUser",
      "Local user account successfully persisted.",
    );
    _debugPrintMessage(
      "_addUser",
      "Persisting user state...",
    );
    // Create user state
    await userStateBox.put(
      localUserId,
      LocalUserAppState(userId: localUserId),
    );
    _debugPrintMessage(
      "_addUser",
      "User state successfully persisted.",
    );
    // Save credentials in encrypted box
    await withEncryptedBox(HiveBoxes.localUserCredentials, (box) async {
      _debugPrintMessage(
        "_addUser",
        "Saving user credentials inside encrypted storage...",
      );
      await box.put(
        localUserId,
        UserCredentials(
          token: token,
          clientCertificate: clientCert,
        ),
      );
      _debugPrintMessage(
        "_addUser",
        "User credentials successfully saved.",
      );
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
    _debugPrintMessage(
      "_getApiVersion",
      "Trying to fetch API version...",
    );
    try {
      final response = await dio.get(
        "/api/",
        options: Options(
          sendTimeout: timeout,
        ),
      );
      final apiVersion =
          int.parse(response.headers.value('x-api-version') ?? "3");
      _debugPrintMessage(
        "_getApiVersion",
        "API version ($apiVersion) successfully retrieved.",
      );
      return apiVersion;
    } on DioException catch (_) {
      return defaultValue;
    }
  }

  /// Fetches possibly updated (permissions, name, updated server version and thus new user model, ...) remote user data.
  Future<void> _updateRemoteUser(
    SessionManager sessionManager,
    LocalUserAccount localUserAccount,
    int apiVersion,
  ) async {
    _debugPrintMessage(
      "_updateRemoteUser",
      "Updating paperless user object...",
    );
    final updatedPaperlessUser = await _apiFactory
        .createUserApi(
          sessionManager.client,
          apiVersion: apiVersion,
        )
        .findCurrentUser();

    localUserAccount.paperlessUser = updatedPaperlessUser;
    await localUserAccount.save();
    _debugPrintMessage(
      "_updateRemoteUser",
      "Paperless user object successfully updated.",
    );
  }

  void _debugPrintMessage(
    String methodName,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    debugPrint("AuthenticationCubit#$methodName: $message");
    if (error != null) {
      debugPrint(error.toString());
    }
    if (stackTrace != null) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
