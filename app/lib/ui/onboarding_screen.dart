import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mal/enums.dart';
import 'package:mal/router.dart';
import 'package:mal/shared/data/onboarding.dart';
import 'package:mal/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _onDone(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefsKeys.seen_onboarding.name, true);

    if (!context.mounted) return;

    context.go('/${Routes.login.name}');
  }

  List<PageViewModel> pages(BuildContext context) {
    return onboardingData
        .map(
          (data) => PageViewModel(
            title: data['title']! as String,
            body: data['body']! as String,
            image: _buildImage(context, data['image']! as IconData),
            decoration: _getPageDecoration(context),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: pages(context),
      onDone: () => _onDone(context),
      onSkip: () => _onDone(context),
      showSkipButton: true,
      skip: Text(
        context.l10n.skip,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      next: const Icon(Icons.arrow_back),
      done: Text(
        context.l10n.start,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(22.0, 10.0),
        activeColor: Theme.of(context).colorScheme.primary,
        color: context.colors.onSurface,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      rtl: true,
      curve: Curves.easeInOut,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 4.0,
      ),
      dotsContainerDecorator: ShapeDecoration(
        color: context.colors.surfaceBright,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      globalBackgroundColor: context.colors.surfaceContainer,
      skipOrBackFlex: 0,
      nextFlex: 0,
    );
  }

  Widget _buildImage(BuildContext context, IconData assetName) {
    final size = MediaQuery.of(context).size;

    return Icon(
      assetName,
      size: size.height * 0.2,
      color: context.colors.onSurface,
    );
  }

  PageDecoration _getPageDecoration(BuildContext context) {
    return PageDecoration(
      titleTextStyle: context.texts.titleLarge!.copyWith(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: context.texts.bodyLarge!.copyWith(fontSize: 18.0),
      imagePadding: const EdgeInsets.only(top: 40),
      pageColor: context.colors.surfaceContainer,
      bodyPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      titlePadding: const EdgeInsets.only(top: 20, bottom: 16),
    );
  }
}
