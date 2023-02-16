import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/service/github_issue_service.dart';
import 'package:paperless_mobile/core/translation/error_code_localization_mapper.dart';
import 'package:paperless_mobile/generated/l10n.dart';

class SnackBarActionConfig {
  final String label;
  final VoidCallback onPressed;

  SnackBarActionConfig({
    required this.label,
    required this.onPressed,
  });
}

void showSnackBar(
  BuildContext context,
  String message, {
  String? details,
  SnackBarActionConfig? action,
  Duration duration = const Duration(seconds: 5),
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: (details != null)
            ? RichText(
                maxLines: 5,
                text: TextSpan(
                  text: message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "\n$details",
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              )
            : Text(message),
        action: action != null
            ? SnackBarAction(
                label: action.label,
                onPressed: action.onPressed,
                textColor: Theme.of(context).colorScheme.onInverseSurface,
              )
            : null,
        duration: duration,
      ),
    );
}

void showGenericError(
  BuildContext context,
  dynamic error, [
  StackTrace? stackTrace,
]) {
  showSnackBar(
    context,
    error.toString(),
    action: SnackBarActionConfig(
      label: S.of(context).report,
      onPressed: () => GithubIssueService.createIssueFromError(
        context,
        stackTrace: stackTrace,
      ),
    ),
  );
  log(
    "An error has occurred.",
    error: error,
    stackTrace: stackTrace,
    time: DateTime.now(),
  );
}

void showLocalizedError(
  BuildContext context,
  String localizedMessage, [
  StackTrace? stackTrace,
]) {
  showSnackBar(context, localizedMessage);
  log(localizedMessage, stackTrace: stackTrace);
}

void showErrorMessage(
  BuildContext context,
  PaperlessServerException error, [
  StackTrace? stackTrace,
]) {
  showSnackBar(
    context,
    translateError(context, error.code),
    details: error.details,
  );
  log(
    "An error has occurred.",
    error: error,
    stackTrace: stackTrace,
    time: DateTime.now(),
  );
}
