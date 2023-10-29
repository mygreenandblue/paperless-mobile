import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/constants.dart';
import 'package:paperless_mobile/core/database/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/global_settings.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/database/tables/local_user_app_state.dart';
import 'package:paperless_mobile/core/database/tables/local_user_settings.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/login/services/authentication_service.dart';
import 'package:provider/provider.dart';

import 'src/fixtures/correspondents.dart';
import 'src/fixtures/document_types.dart';
import 'src/fixtures/documents.dart';
import 'src/fixtures/user.dart';
import 'src/mock/mock_authentication_cubit.dart';
import 'src/mock/mock_connectivity_status_service.dart';
import 'src/mock/mock_local_authentication_service.dart';
import 'src/mock/mock_local_notification_service.dart';
import 'src/mock/mock_paperless_api_factory.dart';
import 'src/tags.dart';
import 'package:mocktail/mocktail.dart';

void main() async {
  final binding = IntegrationTestWidgetsFlutterBinding();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // Create mocks
  final paperlessApiFactory = MockPaperlessApiFactory();
  final mockAuthenticationCubit = MockAuthenticationCubit();
  final connectivityStatusService = MockConnectivityStatusService();
  final localAuthenticationService = MockLocalAuthenticationService();
  final localNotificationService = MockLocalNotificationService();

  const localUserId = "thomas@http://mockhost";
  await Hive.box<LocalUserAccount>(HiveBoxes.localUserAccount).put(
    localUserId,
    LocalUserAccount(
      id: localUserId,
      serverUrl: 'http://mockhost',
      settings: LocalUserSettings(),
      paperlessUser: user1,
      apiVersion: 3,
    ),
  );

  whenListen(
    mockAuthenticationCubit,
    const Stream.empty(),
    initialState: AuthenticatedState(localUserId: "thomas@mockhost"),
  );
  group('Take screenshots', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [],
        ),
      );
      // Load app widget.
      // await tester.pumpWidget(const ());

      // Verify the counter starts at 0.
      expect(find.text('0'), findsOneWidget);

      // Finds the floating action button to tap on.
      final fab = find.byKey(const Key('increment'));

      // Emulate a tap on the floating action button.
      await tester.tap(fab);

      // Trigger a frame.
      await tester.pumpAndSettle();

      // Verify the counter increments by 1.
      expect(find.text('1'), findsOneWidget);
    });
  });
}

Future<void> _initialize(Locale locale) async {
  logger = Logger();
  packageInfo = await PackageInfo.fromPlatform();
  if (Platform.isAndroid) {
    androidInfo = await DeviceInfoPlugin().androidInfo;
  }
  if (Platform.isIOS) {
    iosInfo = await DeviceInfoPlugin().iosInfo;
  }
  await Hive.initFlutter();
  registerHiveAdapters();
  await Hive.openBox<LocalUserAccount>(HiveBoxes.localUserAccount);
  await Hive.openBox<LocalUserAppState>(HiveBoxes.localUserAppState);
  await Hive.openBox<String>(HiveBoxes.hosts);
  final globalSettingsBox =
      await Hive.openBox<GlobalSettings>(HiveBoxes.globalSettings);

  if (!globalSettingsBox.hasValue) {
    await globalSettingsBox.setValue(
      GlobalSettings(preferredLocaleSubtag: locale.toString()),
    );
  }
}

void _initDataBindings() {
  final allCorrespondents = [
    ikeaCorrespondent,
    mediaMarktCorrespondent,
    appleCorrespondent,
  ];
  final allDocumentTypes = [
    invoiceDocumentType,
    contractDocumentType,
  ];

  final allDocuments = [
    document1,
    document2,
    document3,
    document4,
    document5,
    document6,
    document7,
    document8,
    document9,
    document10,
  ];

  final allTags = [
    inboxTag,
    urgentTag,
  ];

  when(() => MockPaperlessApiFactory.documentsApi.findAll(any()))
      .thenAnswer((invocation) => Future.value(
            PagedSearchResult(
              results: allDocuments,
              count: 10,
            ),
          ));
}
