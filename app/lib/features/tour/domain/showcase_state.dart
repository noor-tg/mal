part of 'showcase_cubit.dart';

class ShowcaseState {
  ShowcaseState({required this.keys, this.activeKeys = const []});

  final ShowcaseKeysData keys;
  final List<GlobalKey> activeKeys;

  /// Get keys for showcase widget wrapper
  List<GlobalKey> get wrapperKeys {
    return activeKeys.isEmpty ? [keys.themeSwitcher] : activeKeys;
  }

  ShowcaseState copyWith({
    ShowcaseKeysData? keys,
    List<GlobalKey>? activeKeys,
  }) {
    return ShowcaseState(
      keys: keys ?? this.keys,
      activeKeys: activeKeys ?? this.activeKeys,
    );
  }
}
