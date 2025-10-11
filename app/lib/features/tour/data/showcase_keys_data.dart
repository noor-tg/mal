import 'package:flutter/material.dart';

enum SCKeys {
  themeSwitcher,
  profileBtn,
  newEntryBtn,
  newCategoryBtn,
  searchField,
  filterBtn,
  clearBtn,
}

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
  final categoriesList = GlobalKey();
  final newCategoryBtn = GlobalKey(debugLabel: SCKeys.newCategoryBtn.name);

  // Search Screen Keys
  // final GlobalKey sckSearchBar = GlobalKey();
  final searchResults = GlobalKey();
  final clearBtn = GlobalKey(debugLabel: SCKeys.clearBtn.name);
  final filterBtn = GlobalKey(debugLabel: SCKeys.filterBtn.name);
  final searchField = GlobalKey(debugLabel: SCKeys.searchField.name);

  // Calendar Screen Keys
  final calendarInfo = GlobalKey();
  final dayHeader = GlobalKey();
  final dayList = GlobalKey();

  // Profile Screen Keys
  final avatarInfo = GlobalKey();
  final editName = GlobalKey();
  final editPin = GlobalKey();
  final bioToggle = GlobalKey();
  final downlaodData = GlobalKey();
  final logoutBtn = GlobalKey();

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
        return [categoriesList, newCategoryBtn];
      case 2: // Search
        return [filterBtn, searchField, clearBtn, searchResults];
      case 3: // Calendar
        return [calendarInfo, dayHeader, dayList];
      case 4: // Profile
        return [
          avatarInfo,
          editName,
          editPin,
          bioToggle,
          downlaodData,
          logoutBtn,
        ];
      default:
        return [themeSwitcher, profileBtn, newEntryBtn];
    }
  }
}
