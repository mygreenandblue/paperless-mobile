import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import 'package:edocs_mobile/core/database/hive/hive_config.dart';
import 'package:edocs_mobile/core/database/hive/hive_extensions.dart';
import 'package:edocs_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:edocs_mobile/routing/navigation_keys.dart';

extension AccessibilityAwareAnimationDurationExtension on Duration {
  Duration accessible() {
    bool shouldDisableAnimations = WidgetsBinding.instance.disableAnimations ||
        Hive.globalSettingsBox.getValue()!.disableAnimations;
    // print(shouldDisableAnimations);
    if (shouldDisableAnimations) {
      return 0.seconds;
    }
    return this;
  }
}

extension AccessibleHero on Hero {
  Widget accessible() {
    return GlobalSettingsBuilder(
      builder: (context, settings) {
        return HeroMode(
          enabled: WidgetsBinding.instance.disableAnimations ||
              !settings.disableAnimations,
          child: this,
        );
      },
    );
    // bool shouldDisableAnimations = WidgetsBinding.instance.disableAnimations ||
    //     Hive.globalSettingsBox.getValue()!.disableAnimations;
    // return _AccessibilityAwareObserverWidget(
    //   accessibilityAwareBuilder: (context, accessibilityFeatures) {
    //     return HeroMode(
    //       enabled: !accessibilityFeatures.disableAnimations,
    //       child: this,
    //     );
    //   },
    // );
  }
}

class _AccessibilityAwareObserverWidget extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    AccessibilityFeatures accessibilityFeatures,
  ) accessibilityAwareBuilder;
  const _AccessibilityAwareObserverWidget({
    super.key,
    required this.accessibilityAwareBuilder,
  });

  @override
  State<_AccessibilityAwareObserverWidget> createState() =>
      _AccessibilityAwareObserverWidgetState();
}

class _AccessibilityAwareObserverWidgetState
    extends State<_AccessibilityAwareObserverWidget>
    with WidgetsBindingObserver {
  late final AccessibilityFeatures _accessibilityFeatures;

  @override
  void initState() {
    super.initState();
    _accessibilityFeatures = WidgetsBinding.instance.accessibilityFeatures;
  }

  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    setState(() {
      _accessibilityFeatures = WidgetsBinding.instance.accessibilityFeatures;
    });
    print("Accessibility features changed");
  }

  @override
  Widget build(BuildContext context) {
    return widget.accessibilityAwareBuilder(
      context,
      _accessibilityFeatures,
    );
  }
}
