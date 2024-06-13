import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:edocs_mobile/core/database/hive/hive_config.dart';
import 'package:edocs_mobile/core/database/hive/hive_extensions.dart';
import 'package:edocs_mobile/core/database/hive/hive_initialization.dart';
import 'package:edocs_mobile/core/database/tables/global_settings.dart';
import 'package:edocs_mobile/core/security/session_manager.dart';
import 'package:edocs_mobile/core/service/connectivity_status_service.dart';
import 'package:edocs_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:edocs_mobile/features/login/services/authentication_service.dart';
import 'package:edocs_mobile/features/notifications/services/local_notification_service.dart';
import 'package:edocs_mobile/keys.dart';
import 'package:edocs_mobile/main.dart'
    show initializeDefaultParameters, AppEntrypoint;
import 'package:path_provider/path_provider.dart';

import 'src/mocks/mock_edocs_api.dart';

class MockConnectivityStatusService extends Mock
    implements ConnectivityStatusService {}

class MockLocalAuthService extends Mock implements LocalAuthenticationService {}

class MockSessionManager extends Mock implements SessionManager {}

class MockLocalNotificationService extends Mock
    implements LocalNotificationService {}

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const locale = Locale("en", "US");
  const testServerUrl = 'https://example.com';
  const testUsername = 'user';
  const testPassword = 'pass';

  final hiveDirectory = await getTemporaryDirectory();

  late ConnectivityStatusService connectivityStatusService;
  late MockEdocsApiFactory EdocsApiFactory;
  late AuthenticationCubit authenticationCubit;
  late LocalNotificationService localNotificationService;
  late SessionManager sessionManager;
  final localAuthService = MockLocalAuthService();

  setUp(() async {
    connectivityStatusService = MockConnectivityStatusService();
    EdocsApiFactory = MockEdocsApiFactory();
    sessionManager = MockSessionManager();
    localNotificationService = MockLocalNotificationService();

    authenticationCubit = AuthenticationCubit(
      localAuthService,
      EdocsApiFactory,
      sessionManager,
      connectivityStatusService,
      localNotificationService,
    );
    await initHive(
      hiveDirectory,
      locale.toString(),
    );
  });
  testWidgets(
      'A user shall be successfully logged in when providing correct credentials.',
      (tester) async {
    // Reset data to initial state with given [locale].
    await Hive.globalSettingsBox.setValue(
      GlobalSettings(
        preferredLocaleSubtag: locale.toString(),
        loggedInUserId: null,
      ),
    );
    when(EdocsApiFactory.authenticationApi.login(
      username: testUsername,
      password: testPassword,
    )).thenAnswer((_) async => "token");

    await initializeDefaultParameters();

    await tester.pumpWidget(
      AppEntrypoint(
        apiFactory: EdocsApiFactory,
        authenticationCubit: authenticationCubit,
        connectivityStatusService: connectivityStatusService,
        localNotificationService: localNotificationService,
        localAuthService: localAuthService,
        sessionManager: sessionManager,
      ),
    );
    await tester.binding.waitUntilFirstFrameRasterized;
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(TestKeys.login.serverAddressFormField),
      testServerUrl,
    );
    await tester.pumpAndSettle();

    await tester.press(find.byKey(TestKeys.login.continueButton));

    await tester.pumpAndSettle();
    expect(
      find.byKey(TestKeys.login.usernameFormField),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(TestKeys.login.usernameFormField),
      testUsername,
    );
    await tester.enterText(
      find.byKey(TestKeys.login.passwordFormField),
      testUsername,
    );
    await tester.pumpAndSettle();

    await tester.press(find.byKey(TestKeys.login.loginButton));
    await tester.pumpAndSettle();

    expect(
      find.byKey(TestKeys.login.loggingInScreen),
      findsOneWidget,
    );
  });
}
