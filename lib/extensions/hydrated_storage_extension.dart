import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/settings/cubit/application_settings_cubit.dart';

extension AddressableHydratedStorage on Storage {
  ApplicationSettingsState get settings {
    return ApplicationSettingsState.fromJson(read('ApplicationSettingsCubit'));
  }

  AuthenticationState get authentication {
    return AuthenticationState.fromJson(read('AuthenticationCubit'));
  }
}
