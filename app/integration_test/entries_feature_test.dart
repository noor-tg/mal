import 'dart:io';

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
  entryCreateTest();
  entryDetailsTest();
  entryEditTest();
  // entryDeleteTest();
}

void entryDetailsTest() {
  return patrolTest(
    'check for details view',
    framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    ($) async {
      final app = await initMalApp();

      await generateData();

      await $.pumpWidgetAndSettle(app);

      expect($(AppBar), hasTitleIn([l10n.reportsTitle]));
      await $(
        ListTile,
      ).at(0).scrollTo(scrollDirection: AxisDirection.down).tap();

      expect($(AppBar), hasTitleIn([l10n.income, l10n.expense]));
      expect($(l10n.title), findsOneWidget);
      expect($(Icons.edit), findsOneWidget);
      expect($(Icons.delete), findsOneWidget);
    },
  );
}

void entryCreateTest() {
  return patrolTest(
    'fill entry form successfully and see success message',
    framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    ($) async {
      final app = await initMalApp();

      await $.pumpWidgetAndSettle(app);

      expect($(AppBar), hasTitleIn([l10n.reportsTitle]));
      await $(Icons.create).tap();

      expect($(l10n.newEntry), findsOneWidget);
      expect($(l10n.type), findsOneWidget);
      expect($(l10n.amount), findsOneWidget);
      expect($(l10n.title), findsOneWidget);
      expect($(l10n.notSelected), findsOneWidget);
      expect($(l10n.save), findsOneWidget);
      expect($(l10n.cancel), findsOneWidget);

      await $(l10n.income).tap();

      await $(TextFormField).at(0).enterText('test');
      await $(TextFormField).at(1).enterText('10');
      await $(l10n.save).tap();

      expect($(l10n.entrySavedSuccessfully), findsOneWidget);

      // if (!Platform.isMacOS) {
      //   await $.native.pressHome();
      // }
    },
  );
}

void entryEditTest() {
  return patrolTest(
    'edit existing entry successfully',
    framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    ($) async {
      final app = await initMalApp();

      await generateData();

      await $.pumpWidgetAndSettle(app);

      expect($(AppBar), hasTitleIn([l10n.reportsTitle]));
      await $(
        ListTile,
      ).at(0).scrollTo(scrollDirection: AxisDirection.down).tap();

      expect($(AppBar), hasTitleIn([l10n.income, l10n.expense]));
      expect($(l10n.title), findsWidgets);
      expect($(Icons.edit), findsOneWidget);
      expect($(Icons.delete), findsOneWidget);

      await $(Icons.edit).tap();

      expect($(l10n.editEntry), findsOneWidget);
      expect($(l10n.type), findsOneWidget);
      expect($(l10n.amount), findsOneWidget);
      expect($(l10n.save), findsOneWidget);
      expect($(l10n.cancel), findsOneWidget);

      await $(TextFormField).at(0).enterText('test');
      await $(TextFormField).at(1).enterText('10');
      await $(l10n.save).tap();

      expect($(l10n.entrySavedSuccessfully), findsOneWidget);
    },
  );
}

void entryDeleteTest() {
  return patrolTest(
    'edit existing entry successfully',
    framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    ($) async {
      final app = await initMalApp();

      await generateData();

      await $.pumpWidgetAndSettle(app);

      expect($(AppBar), hasTitleIn([l10n.reportsTitle]));
      await $(
        ListTile,
      ).at(0).scrollTo(scrollDirection: AxisDirection.down).tap();

      expect($(AppBar), hasTitleIn([l10n.income, l10n.expense]));
      expect($(l10n.title), findsWidgets);
      expect($(Icons.edit), findsOneWidget);
      expect($(Icons.delete), findsOneWidget);

      await $(Icons.delete).tap();

      expect($(l10n.entrySavedSuccessfully), findsOneWidget);
    },
  );
}
