import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mal/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    // checkOnBoarding();
    super.initState();
  }

  Future<void> _onDone(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);

    if (context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: 'مرحبا بك في تطبيق مال',
            body: 'تتبع دخلك و منصرفاتك بسهولة',
            image: _buildImage(context, 'assets/onboarding_intro.png'),
            decoration: _getPageDecoration(context),
          ),
          PageViewModel(
            title: 'المدخلات',
            body: 'سجل دخلك و منصرفاتك ببساطة',
            image: _buildImage(context, 'assets/onboarding_entry.png'),
            decoration: _getPageDecoration(context),
          ),
          PageViewModel(
            title: 'الوسوم',
            body: 'قسم بياناتك عبر إضافة وسوم',
            image: _buildImage(context, 'assets/onboarding_categories.png'),
            decoration: _getPageDecoration(context),
          ),
          PageViewModel(
            title: 'تقارير',
            body: 'تتبع بياناتك عبر رسوم بيانية واضحة أو عبر التقويم',
            image: _buildImage(context, 'assets/onboarding_reports.png'),
            decoration: _getPageDecoration(context),
          ),
          PageViewModel(
            title: 'بحث',
            body: 'سهولة البحث عن معلومات سابقة عبر خاصية البحث',
            image: _buildImage(context, 'assets/onboarding_search.png'),
            decoration: _getPageDecoration(context),
          ),
          PageViewModel(
            title: 'تصدير',
            body: 'سهولة إستخراج بيانات المدخلات',
            image: _buildImage(context, 'assets/onboarding_export.png'),
            decoration: _getPageDecoration(context),
          ),
          PageViewModel(
            title: 'مستعد ؟',
            body: 'لنبدأ',
            image: _buildImage(context, 'assets/onboarding_end.png'),
            decoration: _getPageDecoration(context),
          ),
        ],
        onDone: () => _onDone(context),
        onSkip: () => _onDone(context),
        showSkipButton: true,
        skip: const Text('تخطي', style: TextStyle(fontWeight: FontWeight.w600)),
        next: const Icon(Icons.arrow_back), // RTL: back arrow means forward
        done: const Text('ابدأ', style: TextStyle(fontWeight: FontWeight.w600)),
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
        controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsContainerDecorator: ShapeDecoration(
          color: context.colors.surfaceBright,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        globalBackgroundColor: context.colors.surfaceContainer,
        skipOrBackFlex: 0,
        nextFlex: 0,
      ),
    );
  }

  Widget _buildImage(BuildContext context, String assetName) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: Image.asset(
        assetName,
        width: MediaQuery.of(context).size.width * 0.7,
        height: 300,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback for missing images
          return Icon(Icons.image, size: 200, color: context.colors.onSurface);
        },
      ),
    );
  }

  PageDecoration _getPageDecoration(BuildContext context) {
    return PageDecoration(
      titleTextStyle: const TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo', // Use Arabic font
      ),
      bodyTextStyle: const TextStyle(fontSize: 18.0, fontFamily: 'Cairo'),
      imagePadding: const EdgeInsets.only(top: 40),
      pageColor: context.colors.surfaceContainer,
      bodyPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      titlePadding: const EdgeInsets.only(top: 20, bottom: 16),
    );
  }

  // void checkOnBoarding() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   if (!mounted) return;

  //   final seen = prefs.getBool('seen_onboarding');

  //   if (seen != null && seen) {
  //     context.go('/');
  //   }
  // }
}
