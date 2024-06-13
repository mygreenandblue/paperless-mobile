import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_mobile/core/bloc/transient_error.dart';
import 'package:edocs_mobile/core/translation/error_code_localization_mapper.dart';
import 'package:edocs_mobile/features/logging/data/logger.dart';
import 'package:edocs_mobile/helpers/message_helpers.dart';
import 'package:edocs_mobile/routing/navigation_keys.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (error is TransientError) {
      _handleTransientError(bloc, error, stackTrace);
    }
    super.onError(bloc, error, stackTrace);
  }

  void _handleTransientError(
    BlocBase bloc,
    TransientError error,
    StackTrace stackTrace,
  ) {
    assert(rootNavigatorKey.currentContext != null);
    final message = switch (error) {
      TransientedocsApiError(code: var code) => translateError(
          rootNavigatorKey.currentContext!,
          code,
        ),
      TransientMessageError(message: var message) => message,
    };
    final details = switch (error) {
      TransientedocsApiError(details: var details) => details,
      _ => null,
    };

    showSnackBar(
      rootNavigatorKey.currentContext!,
      message,
      details: details,
    );
  }
}
