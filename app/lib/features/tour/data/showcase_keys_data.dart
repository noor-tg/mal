import 'package:flutter/material.dart';

enum SCKeys { themeSwitcher, profileBtn, newEntryBtn }

class ShowcaseKeysData {
  // Global Showcase Keys
  final themeSwitcher = GlobalKey(debugLabel: SCKeys.themeSwitcher.name);
  final profileBtn = GlobalKey(debugLabel: SCKeys.profileBtn.name);
  final newEntryBtn = GlobalKey(debugLabel: SCKeys.newEntryBtn.name);

  // Reports Screen Showcase Keys
  final balanceCard = GlobalKey();
  final monthReport = GlobalKey();
  final pieReport = GlobalKey();
  final todayCard = GlobalKey();

  // Categories Screen Keys
  // final GlobalKey sckCategoryList = GlobalKey();

  // Search Screen Keys
  // final GlobalKey sckSearchBar = GlobalKey();

  // Calendar Screen Keys
  // final GlobalKey sckCalendarView = GlobalKey();

  /// Get showcase keys for a specific tab
  List<GlobalKey> getKeysForTab(int tabIndex) {
    switch (tabIndex) {
      case 0: // Reports
        return [
          themeSwitcher,
          profileBtn,
          balanceCard,
          monthReport,
          pieReport,
          todayCard,
          newEntryBtn,
        ];
      case 1: // Categories
        return [themeSwitcher, profileBtn, newEntryBtn];
      case 2: // Search
        return [themeSwitcher, profileBtn, newEntryBtn];
      case 3: // Calendar
        return [themeSwitcher, profileBtn, newEntryBtn];
      case 4: // Profile
        return [themeSwitcher, profileBtn, newEntryBtn];
      default:
        return [];
    }
  }
}
