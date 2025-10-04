part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class LoadThemeEvent extends ThemeEvent {}

class ChangeThemeEvent extends ThemeEvent {
  final ThemeMode themeMode;
  const ChangeThemeEvent(this.themeMode);
}

class LoadTab extends ThemeEvent {}

class ChangeTab extends ThemeEvent {
  final int index;
  const ChangeTab(this.index);
}
