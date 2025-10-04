import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mal/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const _key = 'theme_mode';

  static const _tabKey = 'current_tab';

  ThemeBloc()
    : super(const ThemeState(themeMode: ThemeMode.system, tabIndex: 0)) {
    on<LoadThemeEvent>(_onLoadThemeEvent);
    on<ChangeThemeEvent>(_onChangeThemeEvent);
    on<LoadTab>(_onLoadTab);
    on<ChangeTab>(_onChangeTab);

    add(LoadThemeEvent()); // load saved theme at startup
    add(LoadTab()); // load saved tab index at startup
  }

  Future<void> _onLoadThemeEvent(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    logger.i(state.props);
    final prefs = await SharedPreferences.getInstance();
    final modeName = prefs.getString(_key);

    final themeMode = ThemeMode.values.firstWhere(
      (e) => e.name == modeName,
      orElse: () => ThemeMode.system,
    );

    emit(state.copyWith(themeMode: themeMode));
    logger.i(state.props);
  }

  Future<void> _onChangeThemeEvent(
    ChangeThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    logger.i(state.props);
    emit(state.copyWith(themeMode: event.themeMode));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, event.themeMode.name);
    logger.i(state.props);
  }

  Future<void> _onLoadTab(LoadTab event, Emitter<ThemeState> emit) async {
    logger.i(state.props);
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getString(_tabKey);

    emit(state.copyWith(tabIndex: index != null ? int.parse(index) : 0));
    logger.i(state.props);
  }

  Future<void> _onChangeTab(ChangeTab event, Emitter<ThemeState> emit) async {
    logger.i(state.props);
    emit(state.copyWith(tabIndex: event.index));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tabKey, event.index.toString());
    logger.i(state.props);
  }
}
