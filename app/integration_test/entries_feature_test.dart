import 'dart:io';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/l10n/app_localizations_ar.dart';
import 'package:mal/main.dart';
// ignore: depend_on_referenced_packages
import 'package:patrol/patrol.dart';

void main() {
  entryFormTest();
  entryDetailsTest();
}

void entryDetailsTest() {
  return patrolTest(
    'check for details view',
    framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    ($) async {
      final app = await initMalApp();

      await $.pumpWidgetAndSettle(app);

      final l10n = AppLocalizationsAr();

      expect($(AppBar).first.$(l10n.reportsTitle), findsOneWidget);
      await $(
        ListTile,
      ).at(0).scrollTo(scrollDirection: AxisDirection.down).tap();

      expect($(l10n.title), findsOneWidget);
      expect($(Icons.edit), findsOneWidget);
      expect($(Icons.delete), findsOneWidget);

      if (!Platform.isMacOS) {
        await $.native.pressHome();
      }
    },
  );
}

void entryFormTest() {
  return patrolTest(
    'fill entry form successfully and see success message',
    framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    ($) async {
      final app = await initMalApp();

      await $.pumpWidgetAndSettle(app);

      final l10n = AppLocalizationsAr();

      expect($(AppBar).first.$(l10n.reportsTitle), findsOneWidget);
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

      if (!Platform.isMacOS) {
        await $.native.pressHome();
      }
    },
  );
}
