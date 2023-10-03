import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/global_settings.dart';
import 'package:paperless_mobile/core/model/info_message_exception.dart';
import 'package:paperless_mobile/features/app_intro/application_intro_slideshow.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/model/login_form_credentials.dart';
import 'package:paperless_mobile/features/login/view/add_account_page.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routes/typed/branches/documents_route.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AddAccountPage(
      titleString: S.of(context)!.connectToPaperless,
      submitText: S.of(context)!.signIn,
      onSubmit: _onLogin,
      showLocalAccounts: true,
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
            credentials: LoginFormCredentials(
              username: username,
              password: password,
            ),
            serverUrl: serverUrl,
            clientCertificate: clientCertificate,
          );
      // Show onboarding after first login!
      final globalSettings =
          Hive.box<GlobalSettings>(HiveBoxes.globalSettings).getValue()!;
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
      // DocumentsRoute().go(context);
    } on PaperlessApiException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    } on PaperlessFormValidationException catch (exception, stackTrace) {
      if (exception.hasUnspecificErrorMessage()) {
        showLocalizedError(context, exception.unspecificErrorMessage()!);
      } else {
        showGenericError(
          context,
          exception.validationMessages.values.first,
          stackTrace,
        ); //TODO: Check if we can show error message directly on field here.
      }
    } on InfoMessageException catch (error) {
      showInfoMessage(context, error);
    } catch (unknownError, stackTrace) {
      showGenericError(context, unknownError.toString(), stackTrace);
    }
  }
}
