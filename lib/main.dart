import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/constants.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/global_settings.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/database/tables/local_user_app_state.dart';
import 'package:paperless_mobile/core/exception/server_message_exception.dart';
import 'package:paperless_mobile/core/factory/paperless_api_factory.dart';
import 'package:paperless_mobile/core/factory/paperless_api_factory_impl.dart';
import 'package:paperless_mobile/core/interceptor/language_header.interceptor.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/core/security/session_manager.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/login/services/authentication_service.dart';
import 'package:paperless_mobile/features/notifications/services/local_notification_service.dart';
import 'package:paperless_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routes/navigation_keys.dart';
import 'package:paperless_mobile/routes/typed/branches/documents_route.dart';
import 'package:paperless_mobile/routes/typed/branches/inbox_route.dart';
import 'package:paperless_mobile/routes/typed/branches/labels_route.dart';
import 'package:paperless_mobile/routes/typed/branches/landing_route.dart';
import 'package:paperless_mobile/routes/typed/branches/saved_views_route.dart';
import 'package:paperless_mobile/routes/typed/branches/scanner_route.dart';
import 'package:paperless_mobile/routes/typed/branches/upload_queue_route.dart';
import 'package:paperless_mobile/routes/typed/shells/provider_shell_route.dart';
import 'package:paperless_mobile/routes/typed/shells/scaffold_shell_route.dart';
import 'package:paperless_mobile/routes/typed/top_level/add_account_route.dart';
import 'package:paperless_mobile/routes/typed/top_level/logging_out_route.dart';
import 'package:paperless_mobile/routes/typed/top_level/login_route.dart';
import 'package:paperless_mobile/routes/typed/top_level/settings_route.dart';
import 'package:paperless_mobile/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String get defaultPreferredLocaleSubtag {
  String preferredLocale = Platform.localeName.split("_").first;
  if (!S.supportedLocales
      .any((locale) => locale.languageCode == preferredLocale)) {
    preferredLocale = 'en';
  }
  return preferredLocale;
}

Map<String, Future<void> Function()> _migrations = {
  '3.0.1': () async {
    // Remove all stored data due to updates in schema
    await Future.wait([
      for (var box in HiveBoxes.all) Hive.deleteBoxFromDisk(box),
    ]);
  },
};

Future<void> performMigrations() async {
  final sp = await SharedPreferences.getInstance();
  final currentVersion = packageInfo.version;
  final migrationExists = _migrations.containsKey(currentVersion);
  if (!migrationExists) {
    return;
  }
  final migrationProcedure = _migrations[currentVersion]!;
  final performedMigrations = sp.getStringList("performed_migrations") ?? [];
  final requiresMigrationForCurrentVersion =
      !performedMigrations.contains(currentVersion);
  if (requiresMigrationForCurrentVersion) {
    debugPrint("Applying migration scripts for version $currentVersion");
    await migrationProcedure();
    await sp.setStringList(
      'performed_migrations',
      [...performedMigrations, currentVersion],
    );
  }
}

Future<void> _initHive() async {
  await Hive.initFlutter();

  // await performMigrations();
  registerHiveAdapters();
  await Hive.openBox<LocalUserAccount>(HiveBoxes.localUserAccount);
  await Hive.openBox<LocalUserAppState>(HiveBoxes.localUserAppState);
  await Hive.openBox<String>(HiveBoxes.hosts);
  final globalSettingsBox =
      await Hive.openBox<GlobalSettings>(HiveBoxes.globalSettings);

  if (!globalSettingsBox.hasValue) {
    await globalSettingsBox.setValue(
      GlobalSettings(preferredLocaleSubtag: defaultPreferredLocaleSubtag),
    );
  }
}

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Paint.enableDithering = true;
    // if (kDebugMode) {
    //   // URL: http://localhost:3131
    //   // Login: admin:test
    //   await LocalMockApiServer(
    //           // RandomDelayGenerator(
    //           //   const Duration(milliseconds: 100),
    //           //   const Duration(milliseconds: 800),
    //           // ),
    //           )
    //       .start();
    // }
    packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      androidInfo = await DeviceInfoPlugin().androidInfo;
    }
    if (Platform.isIOS) {
      iosInfo = await DeviceInfoPlugin().iosInfo;
    }
    await _initHive();
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    final globalSettingsBox =
        Hive.box<GlobalSettings>(HiveBoxes.globalSettings);
    final globalSettings = globalSettingsBox.getValue()!;

    await findSystemLocale();

    final connectivityStatusService = ConnectivityStatusServiceImpl(
      Connectivity(),
    );
    final localAuthService = LocalAuthenticationService(
      LocalAuthentication(),
    );

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
    );

    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    final languageHeaderInterceptor = LanguageHeaderInterceptor(
      globalSettings.preferredLocaleSubtag,
    );
    // Manages security context, required for self signed client certificates
    final sessionManager = SessionManager([
      languageHeaderInterceptor,
    ]);

    // Initialize Blocs/Cubits
    final connectivityCubit = ConnectivityCubit(connectivityStatusService);

    // Load application settings and stored authentication data
    await connectivityCubit.initialize();

    final localNotificationService = LocalNotificationService();
    await localNotificationService.initialize();

    //Update language header in interceptor on language change.
    globalSettingsBox.listenable().addListener(() {
      languageHeaderInterceptor.preferredLocaleSubtag =
          globalSettings.preferredLocaleSubtag;
    });

    final apiFactory = PaperlessApiFactoryImpl(sessionManager);
    final authenticationCubit = AuthenticationCubit(
      localAuthService,
      apiFactory,
      sessionManager,
      connectivityStatusService,
      localNotificationService,
    );
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: sessionManager),
          Provider<LocalAuthenticationService>.value(value: localAuthService),
          Provider<ConnectivityStatusService>.value(
              value: connectivityStatusService),
          Provider<LocalNotificationService>.value(
              value: localNotificationService),
          Provider.value(value: DocumentChangedNotifier()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ConnectivityCubit>.value(value: connectivityCubit),
            BlocProvider.value(value: authenticationCubit),
          ],
          child: GoRouterShell(apiFactory: apiFactory),
        ),
      ),
    );
  }, (error, stack) {
    // Catches all unexpected/uncaught errors and prints them to the console.
    String message = switch (error) {
      PaperlessApiException e => e.details ?? error.toString(),
      ServerMessageException e => e.message,
      _ => error.toString()
    };
    debugPrint("An unepxected exception has occured!");
    debugPrint(message);
    debugPrintStack(stackTrace: stack);
  });
}

class GoRouterShell extends StatefulWidget {
  final PaperlessApiFactory apiFactory;
  const GoRouterShell({
    super.key,
    required this.apiFactory,
  });

  @override
  State<GoRouterShell> createState() => _GoRouterShellState();
}

class _GoRouterShellState extends State<GoRouterShell> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _setOptimalDisplayMode();
    }
    initializeDateFormatting();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<AuthenticationCubit>().restoreSession();
      FlutterNativeSplash.remove();
    });
  }

  /// Activates the highest supported refresh rate on the device.
  Future<void> _setOptimalDisplayMode() async {
    final List<DisplayMode> supported = await FlutterDisplayMode.supported;
    final DisplayMode active = await FlutterDisplayMode.active;

    final List<DisplayMode> sameResolution = supported
        .where((m) => m.width == active.width && m.height == active.height)
        .toList()
      ..sort((a, b) => b.refreshRate.compareTo(a.refreshRate));

    final DisplayMode mostOptimalMode =
        sameResolution.isNotEmpty ? sameResolution.first : active;
    debugPrint('Setting refresh rate to ${mostOptimalMode.refreshRate}');

    await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
  }

  late final _router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: "/login",
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return BlocListener<AuthenticationCubit, AuthenticationState>(
            listener: (context, state) {
              switch (state) {
                case UnauthenticatedState(
                    redirectToAccountSelection: var shouldRedirect
                  ):
                  if (shouldRedirect) {
                    const LoginToExistingAccountRoute().go(context);
                  } else {
                    const LoginRoute().go(context);
                  }
                  break;
                case RestoringSessionState():
                  const RestoringSessionRoute().go(context);
                  break;
                case VerifyIdentityState(userId: var userId):
                  VerifyIdentityRoute(userId: userId).go(context);
                  break;
                case SwitchingAccountsState():
                  const SwitchingAccountsRoute().push(context);
                  break;
                case AuthenticatedState():
                  const LandingRoute().go(context);
                  break;
                case AuthenticatingState state:
                  AuthenticatingRoute(state.currentStage.name).push(context);
                  break;
                case LoggingOutState():
                  const LoggingOutRoute().go(context);
                  break;
                case AuthenticationErrorState():
                  if (context.canPop()) {
                    context.pop();
                  }
                  // LoginRoute(
                  //   $extra: errorState.clientCertificate,
                  //   password: errorState.password,
                  //   serverUrl: errorState.serverUrl,
                  //   username: errorState.username,
                  // ).go(context);
                  break;
              }
            },
            child: child,
          );
        },
        navigatorKey: rootNavigatorKey,
        routes: [
          $loginRoute,
          $loggingOutRoute,
          $addAccountRoute,
          ShellRoute(
            navigatorKey: outerShellNavigatorKey,
            builder: ProviderShellRoute(widget.apiFactory).build,
            routes: [
              $settingsRoute,
              $savedViewsRoute,
              $uploadQueueRoute,
              StatefulShellRoute(
                navigatorContainerBuilder:
                    (context, navigationShell, children) {
                  return children[navigationShell.currentIndex];
                },
                builder: const ScaffoldShellRoute().builder,
                branches: [
                  StatefulShellBranch(
                    navigatorKey: landingNavigatorKey,
                    routes: [$landingRoute],
                  ),
                  StatefulShellBranch(
                    navigatorKey: documentsNavigatorKey,
                    routes: [$documentsRoute],
                  ),
                  StatefulShellBranch(
                    navigatorKey: scannerNavigatorKey,
                    routes: [$scannerRoute],
                  ),
                  StatefulShellBranch(
                    navigatorKey: labelsNavigatorKey,
                    routes: [$labelsRoute],
                  ),
                  StatefulShellBranch(
                    navigatorKey: inboxNavigatorKey,
                    routes: [$inboxRoute],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return GlobalSettingsBuilder(
      builder: (context, settings) {
        return DynamicColorBuilder(
          builder: (lightDynamic, darkDynamic) {
            return MaterialApp.router(
              routerConfig: _router,
              debugShowCheckedModeBanner: true,
              title: "Paperless Mobile",
              theme: buildTheme(
                brightness: Brightness.light,
                dynamicScheme: lightDynamic,
                preferredColorScheme: settings.preferredColorSchemeOption,
              ),
              darkTheme: buildTheme(
                brightness: Brightness.dark,
                dynamicScheme: darkDynamic,
                preferredColorScheme: settings.preferredColorSchemeOption,
              ),
              themeMode: settings.preferredThemeMode,
              supportedLocales: S.supportedLocales,
              locale: Locale.fromSubtags(
                languageCode: settings.preferredLocaleSubtag,
              ),
              localizationsDelegates: S.localizationsDelegates,
            );
          },
        );
      },
    );
  }
}
