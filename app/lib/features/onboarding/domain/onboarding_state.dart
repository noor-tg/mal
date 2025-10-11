part of 'onboarding_cubit.dart';

class OnboardingState {
  final bool onboardingSeen;

  const OnboardingState({this.onboardingSeen = false});

  OnboardingState copyWith({required bool isSeen}) {
    return OnboardingState(onboardingSeen: isSeen);
  }
}
