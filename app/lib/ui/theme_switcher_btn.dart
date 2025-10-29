import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/shared/domain/bloc/theme/theme_bloc.dart';
import 'package:mal/utils.dart';
import 'package:showcaseview/showcaseview.dart';

class ThemeSwitcherBtn extends StatelessWidget {
  final ThemeMode activeMode;
  final GlobalKey showCaseKey;
  const ThemeSwitcherBtn({
    super.key,
    required this.activeMode,
    required this.showCaseKey,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: showCaseKey,
      description: context.l10n.showCaseDescriptionThemeSwitcher,
      child: Transform.rotate(
        angle: 60,
        child: IconButton(
          icon: Icon(
            activeMode == ThemeMode.light
                ? Icons.nightlight_round_rounded
                : Icons.sunny,
            color: context.colors.onSurfaceVariant.withAlpha(200),
          ),
          onPressed: () {
            context.read<ThemeBloc>().add(
              ChangeThemeEvent(
                activeMode == ThemeMode.light
                    ? ThemeMode.dark
                    : ThemeMode.light,
              ),
            );
          },
        ),
      ),
    );
  }
}
