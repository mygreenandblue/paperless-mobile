import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/model/info_message_exception.dart';
import 'package:edocs_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:edocs_mobile/features/login/model/login_form_credentials.dart';
import 'package:edocs_mobile/features/login/view/add_account_page.dart';
import 'package:edocs_mobile/features/settings/view/dialogs/switch_account_dialog.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:edocs_mobile/helpers/message_helpers.dart';
import 'package:edocs_mobile/routing/navigation_keys.dart';
import 'package:edocs_mobile/routing/routes.dart';

part 'add_account_route.g.dart';

@TypedGoRoute<AddAccountRoute>(
  path: '/add-account',
  name: R.addAccount,
)
class AddAccountRoute extends GoRouteData {
  const AddAccountRoute();

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      child: AddAccountPage(
        titleText: S.of(context)!.addAccount,
        onSubmit:
            (context, username, password, serverUrl, clientCertificate) async {
          try {
            final userId = await context.read<AuthenticationCubit>().addAccount(
                  credentials: LoginFormCredentials(
                    username: username,
                    password: password,
                  ),
                  clientCertificate: clientCertificate,
                  serverUrl: serverUrl,
                  enableBiometricAuthentication: false,
                  locale: Intl.getCurrentLocale(),
                );
            final shoudSwitch = await showDialog<bool>(
                  context: context,
                  builder: (context) => const SwitchAccountDialog(),
                ) ??
                false;
            if (shoudSwitch) {
              await context.read<AuthenticationCubit>().switchAccount(userId);
            } else {
              while (context.canPop()) {
                context.pop();
              }
            }
          } on EdocsApiException catch (error, stackTrace) {
            showErrorMessage(context, error, stackTrace);
            // context.pop();
          } on edocsFormValidationException catch (exception, stackTrace) {
            if (exception.hasUnspecificErrorMessage()) {
              showLocalizedError(context, exception.unspecificErrorMessage()!);
              // context.pop();
            } else {
              showGenericError(
                context,
                exception.validationMessages.values.first,
                stackTrace,
              ); //TODO: Check if we can show error message directly on field here.
            }
          } on InfoMessageException catch (error) {
            showInfoMessage(context, error);
            // context.pop();
          } catch (unknownError, stackTrace) {
            showGenericError(context, unknownError.toString(), stackTrace);
            // context.pop();
          }
        },
        submitText: S.of(context)!.addAccount,
      ),
    );
  }
}
