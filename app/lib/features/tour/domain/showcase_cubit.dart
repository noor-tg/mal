import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mal/features/tour/data/showcase_keys_data.dart';
import 'package:mal/utils/logger.dart';

part 'showcase_state.dart';

class ShowcaseCubit extends Cubit<ShowcaseState> {
  ShowcaseCubit() : super(ShowcaseState(keys: ShowcaseKeysData()));

  /// Activate showcase for a specific tab
  void activateShowcaseForTab(int tabIndex) {
    final keysForTab = state.keys.getKeysForTab(tabIndex);
    logger.i(keysForTab);
    emit(state.copyWith(activeKeys: keysForTab));
  }

  /// Get keys for showcase widget wrapper
  List<GlobalKey> get wrapperKeys {
    return state.activeKeys.isEmpty
        ? [state.keys.themeSwitcher]
        : state.activeKeys;
  }

  /// Access keys directly
  ShowcaseKeysData get keys => state.keys;
}
