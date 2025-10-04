part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState({required this.themeMode, required this.tabIndex});

  final ThemeMode themeMode;
  final int tabIndex;

  ThemeState copyWith({ThemeMode? themeMode, int? tabIndex}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }

  @override
  List<Object> get props => [themeMode, tabIndex];
}
