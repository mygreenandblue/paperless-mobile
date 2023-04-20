import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' as cm;
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/constants.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/bloc/paperless_server_information_cubit.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/interceptor/dio_http_error_interceptor.dart';
import 'package:paperless_mobile/core/interceptor/language_header.interceptor.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/repository/saved_view_repository.dart';
import 'package:paperless_mobile/core/security/session_manager.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/core/service/dio_file_service.dart';
import 'package:paperless_mobile/core/type/types.dart';
import 'package:paperless_mobile/features/app_intro/application_intro_slideshow.dart';
import 'package:paperless_mobile/features/home/view/home_page.dart';
import 'package:paperless_mobile/features/home/view/widget/verify_identity_page.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/model/login_form_credentials.dart';
import 'package:paperless_mobile/features/login/model/user_account.dart';
import 'package:paperless_mobile/features/login/services/authentication_service.dart';
import 'package:paperless_mobile/features/login/view/login_page.dart';
import 'package:paperless_mobile/features/notifications/services/local_notification_service.dart';
import 'package:paperless_mobile/features/settings/model/global_settings.dart';
import 'package:paperless_mobile/features/settings/model/user_settings.dart';
import 'package:paperless_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:paperless_mobile/features/sharing/share_intent_queue.dart';
import 'package:paperless_mobile/features/tasks/cubit/task_status_cubit.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routes/document_details_route.dart';
import 'package:paperless_mobile/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

String get defaultPreferredLocaleSubtag {
  String preferredLocale = Platform.localeName.split("_").first;
  if (!S.supportedLocales.any((locale) => locale.languageCode == preferredLocale)) {
    preferredLocale = 'en';
  }
  return preferredLocale;
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  //TODO: REMOVE!
  // await getApplicationDocumentsDirectory().then((value) => value.delete(recursive: true));

  registerHiveAdapters();
  await Hive.openBox<UserAccount>(HiveBoxes.userAccount);
  await Hive.openBox<UserSettings>(HiveBoxes.userSettings);
  final globalSettingsBox = await Hive.openBox<GlobalSettings>(HiveBoxes.globalSettings);

  if (!globalSettingsBox.hasValue) {
    await globalSettingsBox
        .setValue(GlobalSettings(preferredLocaleSubtag: defaultPreferredLocaleSubtag));
  }
}

void main() async {
  await _initHive();
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  final globalSettingsBox = Hive.box<GlobalSettings>(HiveBoxes.globalSettings);
  final globalSettings = globalSettingsBox.getValue()!;

  await findSystemLocale();
  packageInfo = await PackageInfo.fromPlatform();
  if (Platform.isAndroid) {
    androidInfo = await DeviceInfoPlugin().androidInfo;
  }
  if (Platform.isIOS) {
    iosInfo = await DeviceInfoPlugin().iosInfo;
  }

  // Initialize External dependencies
  final connectivity = Connectivity();
  final localAuthentication = LocalAuthentication();
  // Initialize other utility classes
  final connectivityStatusService = ConnectivityStatusServiceImpl(connectivity);
  final localAuthService = LocalAuthenticationService(localAuthentication);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final languageHeaderInterceptor = LanguageHeaderInterceptor(
    globalSettings.preferredLocaleSubtag,
  );
  // Manages security context, required for self signed client certificates
  final sessionManager = SessionManager([
    DioHttpErrorInterceptor(),
    languageHeaderInterceptor,
  ]);

  // Initialize Paperless APIs
  final authApi = PaperlessAuthenticationApiImpl(sessionManager.client);
  final documentsApi = PaperlessDocumentsApiImpl(sessionManager.client);
  final labelsApi = PaperlessLabelApiImpl(sessionManager.client);
  final statsApi = PaperlessServerStatsApiImpl(sessionManager.client);
  final savedViewsApi = PaperlessSavedViewsApiImpl(sessionManager.client);
  final tasksApi = PaperlessTasksApiImpl(
    sessionManager.client,
  );

  // Initialize Blocs/Cubits
  final connectivityCubit = ConnectivityCubit(connectivityStatusService);

  // Load application settings and stored authentication data
  await connectivityCubit.initialize();

  // Create repositories
  final labelRepository = LabelRepository(labelsApi);
  final savedViewRepository = SavedViewRepository(savedViewsApi);

  //Create cubits/blocs
  final authCubit = AuthenticationCubit(
    localAuthService,
    authApi,
    sessionManager,
    labelRepository,
    savedViewRepository,
    statsApi,
  );

  if (globalSettings.currentLoggedInUser != null) {
    await authCubit.restoreSessionState();
  }

  final localNotificationService = LocalNotificationService();
  await localNotificationService.initialize();

  //Update language header in interceptor on language change.
  globalSettingsBox.listenable().addListener(() {
    languageHeaderInterceptor.preferredLocaleSubtag = globalSettings.preferredLocaleSubtag;
  });

  runApp(
    MultiProvider(
      providers: [
        Provider<LocalAuthenticationService>.value(value: localAuthService),
        Provider<PaperlessAuthenticationApi>.value(value: authApi),
        Provider<PaperlessDocumentsApi>.value(value: documentsApi),
        Provider<PaperlessLabelsApi>.value(value: labelsApi),
        Provider<PaperlessServerStatsApi>.value(value: statsApi),
        Provider<PaperlessSavedViewsApi>.value(value: savedViewsApi),
        Provider<PaperlessTasksApi>.value(value: tasksApi),
        Provider<cm.CacheManager>(
          create: (context) => cm.CacheManager(
            cm.Config(
              'cacheKey',
              fileService: DioFileService(sessionManager.client),
            ),
          ),
        ),
        Provider<ConnectivityStatusService>.value(
          value: connectivityStatusService,
        ),
        Provider<LocalNotificationService>.value(value: localNotificationService),
        Provider.value(value: DocumentChangedNotifier()),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<LabelRepository>.value(
            value: labelRepository,
          ),
          RepositoryProvider<SavedViewRepository>.value(
            value: savedViewRepository,
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationCubit>.value(value: authCubit),
            BlocProvider<ConnectivityCubit>.value(value: connectivityCubit),
          ],
          child: const PaperlessMobileEntrypoint(),
        ),
      ),
    ),
  );
}

class PaperlessMobileEntrypoint extends StatefulWidget {
  const PaperlessMobileEntrypoint({
    Key? key,
  }) : super(key: key);

  @override
  State<PaperlessMobileEntrypoint> createState() => _PaperlessMobileEntrypointState();
}

class _PaperlessMobileEntrypointState extends State<PaperlessMobileEntrypoint> {
  @override
  Widget build(BuildContext context) {
    return GlobalSettingsBuilder(
      builder: (context, settings) {
        return DynamicColorBuilder(
          builder: (lightDynamic, darkDynamic) {
            return MaterialApp(
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
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              routes: {
                DocumentDetailsRoute.routeName: (context) => const DocumentDetailsRoute(),
              },
              home: const AuthenticationWrapper(),
            );
          },
        );
      },
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FlutterNativeSplash.remove();
  }

  @override
  void initState() {
    super.initState();

    // Activate the highest supported refresh rate on the device
    if (Platform.isAndroid) {
      _setOptimalDisplayMode();
    }
    initializeDateFormatting();
    // For sharing files coming from outside the app while the app is still opened
    ReceiveSharingIntent.getMediaStream().listen(ShareIntentQueue.instance.addAll);
    // For sharing files coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then(ShareIntentQueue.instance.addAll);
  }

  Future<void> _setOptimalDisplayMode() async {
    final List<DisplayMode> supported = await FlutterDisplayMode.supported;
    final DisplayMode active = await FlutterDisplayMode.active;

    final List<DisplayMode> sameResolution = supported
        .where((m) => m.width == active.width && m.height == active.height)
        .toList()
      ..sort((a, b) => b.refreshRate.compareTo(a.refreshRate));

    final DisplayMode mostOptimalMode = sameResolution.isNotEmpty ? sameResolution.first : active;
    debugPrint('Setting refresh rate to ${mostOptimalMode.refreshRate}');

    await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, authentication) {
        if (authentication.isAuthenticated) {
          return MultiBlocProvider(
            // This key will cause the subtree to be remounted, which will again
            // call the provider's create callback! Without this key, the blocs
            // would not be recreated on account switch!
            key: ValueKey(authentication.userId),
            providers: [
              BlocProvider(
                create: (context) => TaskStatusCubit(
                  context.read<PaperlessTasksApi>(),
                ),
              ),
              BlocProvider<PaperlessServerInformationCubit>(
                create: (context) => PaperlessServerInformationCubit(
                  context.read<PaperlessServerStatsApi>(),
                ),
              ),
            ],
            child: const HomePage(),
          );
        } else if (authentication.showBiometricAuthenticationScreen) {
          return const VerifyIdentityPage();
        }
        return LoginPage(
          submitText: S.of(context)!.signIn,
          onSubmit: _onLogin,
        );
      },
    );
  }

  void _onLogin(
    BuildContext context,
    String username,
    String password,
    String serverUrl,
    ClientCertificate? clientCertificate,
  ) async {
    try {
      await context.read<AuthenticationCubit>().login(
            credentials: LoginFormCredentials(username: username, password: password),
            serverUrl: serverUrl,
            clientCertificate: clientCertificate,
          );
      // Show onboarding after first login!
      final globalSettings = GlobalSettings.boxedValue;
      if (globalSettings.showOnboarding) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ApplicationIntroSlideshow(),
            fullscreenDialog: true,
          ),
        ).then((value) {
          globalSettings.showOnboarding = false;
          globalSettings.save();
        });
      }
    } on PaperlessServerException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    } on PaperlessValidationErrors catch (error, stackTrace) {
      if (error.hasFieldUnspecificError) {
        showLocalizedError(context, error.fieldUnspecificError!);
      } else {
        showGenericError(context, error.values.first, stackTrace);
      }
    } catch (unknownError, stackTrace) {
      showGenericError(context, unknownError.toString(), stackTrace);
    }
  }
}
