import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/theme.dart';

class LoginTransitionPage extends StatelessWidget {
  final String text;
  const LoginTransitionPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: buildOverlayStyle(
          Theme.of(context),
          systemNavigationBarColor: Theme.of(context).colorScheme.background,
        ),
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              const CircularProgressIndicator(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(text).paddedOnly(bottom: 24),
              ),
            ],
          ).padded(16),
        ),
      ),
    );
  }
}
