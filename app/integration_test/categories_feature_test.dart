import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/data.dart';
import 'package:mal/l10n/app_localizations_ar.dart';
import 'package:mal/main.dart';
// ignore: depend_on_referenced_packages
import 'package:patrol/patrol.dart';

import 'test_utils.dart';

final l10n = AppLocalizationsAr();

void main() {
  categoryCreateTest();
  categoriesListTest();
  categoryRemoveTest();
}

void categoryRemoveTest() {
  return patrolTest(
    'remove single category',
    framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    ($) async {
      final app = await initMalApp();

      await clearCategories();

      await $.pumpWidgetAndSettle(app);

      expect($(AppBar), hasTitleIn([l10n.reportsTitle]));
      await $($(l10n.tabCategoriesLabel)).tap();

      expect($(Icons.dashboard_customize), findsOneWidget);
      expect($(l10n.income), findsOneWidget);
      expect($(l10n.expenses), findsOneWidget);
      for (final category in categories) {
        expect($(category.title), findsOneWidget);
      }

      await $.tester.drag(
        $(categories[0].title),
        Offset($.tester.getSize(find.byType(Dismissible).first).width, 0),
      );

      await Future.delayed(const Duration(milliseconds: 100));

      expect($(categories[0].title), findsNothing);
    },
  );
}

void categoriesListTest() {
  return patrolTest(
    'list existing categories',
    framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    ($) async {
      final app = await initMalApp();

      await clearCategories();

      await $.pumpWidgetAndSettle(app);

      expect($(AppBar), hasTitleIn([l10n.reportsTitle]));
      await $($(l10n.tabCategoriesLabel)).tap();

      expect($(Icons.dashboard_customize), findsOneWidget);
      expect($(l10n.income), findsOneWidget);
      expect($(l10n.expenses), findsOneWidget);
      for (final category in categories) {
        expect($(category.title), findsOneWidget);
      }
    },
  );
}

void categoryCreateTest() {
  return patrolTest(
    'add new category successfully',
    framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    ($) async {
      final app = await initMalApp();

      await clearCategories();

      await $.pumpWidgetAndSettle(app);

      expect($(AppBar), hasTitleIn([l10n.reportsTitle]));
      await $($(l10n.tabCategoriesLabel)).tap();
      await $(Icons.dashboard_customize).tap();

      expect($(l10n.newCategory), findsOneWidget);
      expect($(l10n.title), findsOneWidget);
      expect($(l10n.save), findsOneWidget);
      expect($(l10n.cancel), findsOneWidget);

      await $(l10n.income).tap();

      await $(TextFormField).at(0).enterText('مستقل');
      await $(l10n.save).tap();

      expect($(l10n.categoresSavedSuccessfully), findsOneWidget);

      expect($('مستقل'), findsOneWidget);
    },
  );
}
