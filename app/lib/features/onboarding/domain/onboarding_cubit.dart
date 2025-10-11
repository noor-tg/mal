import 'package:bloc/bloc.dart';
import 'package:mal/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  Future<void> markOnboardingAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefsKeys.seen_onboarding.name, true);

    emit(state.copyWith(isSeen: true));
  }

  Future<void> loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isSeen = prefs.getBool(PrefsKeys.seen_onboarding.name) ?? false;

    emit(state.copyWith(isSeen: isSeen));
  }
}
