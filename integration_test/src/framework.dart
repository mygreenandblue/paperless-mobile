import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paperless_mobile/core/factory/paperless_api_factory.dart';
import 'package:paperless_mobile/core/security/session_manager.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/login/services/authentication_service.dart';
import 'package:paperless_mobile/features/notifications/services/local_notification_service.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/main.dart'
    show initializeDefaultParameters, AppEntrypoint;
import 'package:path_provider/path_provider.dart';

Future<TestingFrameworkVariables> initializeTestingFramework(
    {String languageCode = 'en'}) async {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final translations = await S.delegate.load(
    Locale.fromSubtags(
      languageCode: languageCode,
    ),
  );
  return TestingFrameworkVariables(
    binding: binding,
    translations: translations,
  );
}

class TestingFrameworkVariables {
  final IntegrationTestWidgetsFlutterBinding binding;
  final S translations;

  TestingFrameworkVariables({
    required this.binding,
    required this.translations,
  });
}
