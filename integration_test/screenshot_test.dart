// import 'dart:async';
// import 'dart:io';

// import 'package:bloc_test/bloc_test.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_driver/flutter_driver.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:logger/logger.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:paperless_api/paperless_api.dart';
// import 'package:paperless_mobile/constants.dart';
// import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
// import 'package:paperless_mobile/core/database/hive/hive_config.dart';
// import 'package:paperless_mobile/core/database/tables/global_settings.dart';
// import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
// import 'package:paperless_mobile/core/database/tables/local_user_app_state.dart';
// import 'package:paperless_mobile/core/database/tables/local_user_settings.dart';
// import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
// import 'package:paperless_mobile/features/logging/data/logger.dart';
// import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
// import 'package:paperless_mobile/features/login/services/authentication_service.dart';
// import 'package:paperless_mobile/features/notifications/services/local_notification_service.dart';
// import 'package:paperless_mobile/main.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';

// import 'src/fixtures/correspondents.dart';
// import 'src/fixtures/document_types.dart';
// import 'src/fixtures/documents.dart';
// import 'src/fixtures/user.dart';
// import 'src/isolate_workaround.dart';
// import 'src/mock/mock_authentication_cubit.dart';
// import 'src/mock/mock_connectivity_status_service.dart';
// import 'src/mock/mock_local_authentication_service.dart';
// import 'src/mock/mock_local_notification_service.dart';
// import 'src/mock/mock_paperless_api_factory.dart';
// import 'src/tags.dart';

// void main() async {
//   final binding = IntegrationTestWidgetsFlutterBinding();

//   final locale = Locale("de");
//   const localUserId = "thomas@http://mockhost";
//   FlutterDriver? driver;
//   // Connect to the Flutter driver before running any tests.
//   setUpAll(() async {
//     registerFallbackValue(const DocumentFilter());
//     await _setUpDocumentApi();
//     _setUpLabelApi();
//     driver = await FlutterDriver.connect();
//     await driver?.waitUntilFirstFrameRasterized();
//   });

//   // Close the connection to the driver after the tests have completed.
//   tearDownAll(() async {
//     await driver?.close();
//   });
//   await _initialize(locale);
//   await Hive.box<LocalUserAccount>(HiveBoxes.localUserAccount).put(
//     localUserId,
//     LocalUserAccount(
//       id: localUserId,
//       serverUrl: 'http://mockhost',
//       settings: LocalUserSettings(),
//       paperlessUser: user1,
//       apiVersion: 3,
//     ),
//   );

//   // Create mocks
//   final paperlessApiFactory = MockPaperlessApiFactory();
//   final mockAuthenticationCubit = MockAuthenticationCubit();
//   final connectivityStatusService = MockConnectivityStatusService();
//   final localAuthenticationService = MockLocalAuthenticationService();
//   final localNotificationService = MockLocalNotificationService();

//   whenListen(
//     mockAuthenticationCubit,
//     const Stream.empty(),
//     initialState: AuthenticatedState(localUserId: localUserId),
//   );
//   testWidgets('Launch app and take screenshot', (tester) async {
//     print("Starting application...");
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           Provider<LocalAuthenticationService>.value(
//               value: localAuthenticationService),
//           Provider<ConnectivityStatusService>.value(
//               value: connectivityStatusService),
//           Provider<LocalNotificationService>.value(
//               value: localNotificationService),
//           Provider<ConnectivityCubit>.value(
//               value: ConnectivityCubit(connectivityStatusService)),
//           Provider<AuthenticationCubit>.value(value: mockAuthenticationCubit),
//         ],
//         child: GoRouterShell(
//           apiFactory: paperlessApiFactory,
//           initialLocation: '/documents',
//         ),
//       ),
//     );
//     // await binding.convertFlutterSurfaceToImage();
//     await tester.pumpAndSettle();
//     debugPrint("Frame rendered, taking screenshot...");

//     binding.takeScreenshot("test");
//   });
// }

// Future<void> _initialize(Locale locale) async {
//   logger = Logger();
//   packageInfo = await PackageInfo.fromPlatform();
//   if (Platform.isAndroid) {
//     androidInfo = await DeviceInfoPlugin().androidInfo;
//   }
//   if (Platform.isIOS) {
//     iosInfo = await DeviceInfoPlugin().iosInfo;
//   }
//   Hive.init((await getApplicationDocumentsDirectory()).path);
//   registerHiveAdapters();
//   await Hive.openBox<LocalUserAccount>(HiveBoxes.localUserAccount);
//   await Hive.openBox<LocalUserAppState>(HiveBoxes.localUserAppState);
//   await Hive.openBox<String>(HiveBoxes.hosts);
//   final globalSettingsBox =
//       await Hive.openBox<GlobalSettings>(HiveBoxes.globalSettings);

//   if (!globalSettingsBox.hasValue) {
//     await globalSettingsBox.setValue(
//       GlobalSettings(preferredLocaleSubtag: locale.toString()),
//     );
//   }
// }

// Future<void> _setUpDocumentApi() async {
//   final allDocuments = [
//     document1,
//     document2,
//     document3,
//     document4,
//     document5,
//     document6,
//     document7,
//     document8,
//     document9,
//     document10,
//   ];

//   when(() => MockPaperlessApiFactory.documentsApi.findAll(any())).thenAnswer(
//     (invocation) => Future.value(
//       PagedSearchResult(
//         results: allDocuments,
//         count: 10,
//       ),
//     ),
//   );
//   // final documentBytes = (await rootBundle
//   //         .load("integration_test/src/fixtures/preview/example_document.pdf"))
//   //     .buffer
//   //     .asUint8List();
//   // when(() => MockPaperlessApiFactory.documentsApi.downloadDocument(any()))
//   //     .thenAnswer((invocation) => Future.value(documentBytes));
//   when(() => MockPaperlessApiFactory.documentsApi.find(any()))
//       .thenAnswer((invocation) => Future.value(document1));
// }

// void _setUpLabelApi() {
//   final allCorrespondents = [
//     ikeaCorrespondent,
//     mediaMarktCorrespondent,
//     appleCorrespondent,
//   ];
//   final allDocumentTypes = [
//     invoiceDocumentType,
//     contractDocumentType,
//   ];

//   final allTags = [
//     inboxTag,
//     urgentTag,
//   ];
//   final api = MockPaperlessApiFactory.labelsApi;
//   when(() => api.getCorrespondents())
//       .thenAnswer((invocation) async => allCorrespondents);
//   when(() => api.getDocumentTypes())
//       .thenAnswer((invocation) async => allDocumentTypes);
//   when(() => api.getTags()).thenAnswer((invocation) async => allTags);
//   when(() => api.getTag(any())).thenAnswer((invocation) async => urgentTag);
//   when(() => api.getCorrespondent(any()))
//       .thenAnswer((invocation) async => ikeaCorrespondent);
//   when(() => api.getDocumentType(any()))
//       .thenAnswer((invocation) async => invoiceDocumentType);
// }
