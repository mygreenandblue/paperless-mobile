import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:edocs_mobile/core/global/asset_images.dart';
import 'package:edocs_mobile/features/settings/view/widgets/biometric_authentication_setting.dart';
import 'package:edocs_mobile/features/settings/view/widgets/language_selection_setting.dart';
import 'package:edocs_mobile/features/settings/view/widgets/theme_mode_setting.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

class ApplicationIntroSlideshow extends StatefulWidget {
  const ApplicationIntroSlideshow({super.key});

  @override
  State<ApplicationIntroSlideshow> createState() =>
      _ApplicationIntroSlideshowState();
}

//TODO: INTL ALL
class _ApplicationIntroSlideshowState extends State<ApplicationIntroSlideshow> {
  AssetImage secureImage = AssetImages.secureDocuments.image;
  AssetImage successImage = AssetImages.success.image;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: IntroductionScreen(
        globalBackgroundColor: Theme.of(context).canvasColor,
        showDoneButton: true,
        next: Text(S.of(context)!.next),
        done: Text(S.of(context)!.done),
        onDone: () {
          Navigator.pop(context);
        },
        dotsDecorator: DotsDecorator(
          color: Theme.of(context).colorScheme.onBackground,
          activeColor: Theme.of(context).colorScheme.primary,
          activeSize: const Size(16.0, 8.0),
          activeShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        pages: [
          PageViewModel(
            titleWidget: Text(
              "Always right at your fingertip",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            image: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: AssetImages.organizeDocuments.image,
              ),
            ),
            bodyWidget: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Organizing documents was never this easy",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          PageViewModel(
            titleWidget: Text(
              "Accessible only by you",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            image: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(image: AssetImages.secureDocuments.image),
            ),
            bodyWidget: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Secure your documents with biometric authentication and client certificates",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          PageViewModel(
            titleWidget: Text(
              "You're almost done",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            image: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(image: AssetImages.success.image),
            ),
            bodyWidget: const Column(
              children: [
                BiometricAuthenticationSetting(),
                LanguageSelectionSetting(),
                ThemeModeSetting(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
