import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ar')];

  /// reports screen title
  ///
  /// In ar, this message translates to:
  /// **'تقارير'**
  String get reportsTitle;

  /// No description provided for @tabReportsLabel.
  ///
  /// In ar, this message translates to:
  /// **'تقارير'**
  String get tabReportsLabel;

  /// No description provided for @tabCalendarLabel.
  ///
  /// In ar, this message translates to:
  /// **'تقوم'**
  String get tabCalendarLabel;

  /// No description provided for @tabSearchLabel.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get tabSearchLabel;

  /// No description provided for @tabCategoriesLabel.
  ///
  /// In ar, this message translates to:
  /// **'وسوم'**
  String get tabCategoriesLabel;

  /// No description provided for @reportsBalance.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد'**
  String get reportsBalance;

  /// No description provided for @expenses.
  ///
  /// In ar, this message translates to:
  /// **'المنصرفات'**
  String get expenses;

  /// No description provided for @income.
  ///
  /// In ar, this message translates to:
  /// **'دخل'**
  String get income;

  /// No description provided for @newCategory.
  ///
  /// In ar, this message translates to:
  /// **'إضافة وسم'**
  String get newCategory;

  /// No description provided for @categoryTitle.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get categoryTitle;

  /// No description provided for @categoryType.
  ///
  /// In ar, this message translates to:
  /// **'النوع'**
  String get categoryType;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @expense.
  ///
  /// In ar, this message translates to:
  /// **'منصرف'**
  String get expense;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @categoryTitleErrorMessage.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال العنوان بقيمة حرفين على الاقل'**
  String get categoryTitleErrorMessage;

  /// No description provided for @pleaseAddCorrectInfo.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال النوع و العنوان'**
  String get pleaseAddCorrectInfo;

  /// No description provided for @categoryTypeErrorMessage.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إختيار النوع'**
  String get categoryTypeErrorMessage;

  /// No description provided for @emptyCategoriesList.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد وسوم مضافة'**
  String get emptyCategoriesList;

  /// No description provided for @remove.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get remove;

  /// No description provided for @amount.
  ///
  /// In ar, this message translates to:
  /// **'القيمة'**
  String get amount;

  /// No description provided for @category.
  ///
  /// In ar, this message translates to:
  /// **'وسم'**
  String get category;

  /// No description provided for @newEntry.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل مدخل'**
  String get newEntry;

  /// No description provided for @amountErrorMessage.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال قيمة أكثر من 0'**
  String get amountErrorMessage;

  /// No description provided for @entrySavedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل المدخل بنحاج'**
  String get entrySavedSuccessfully;

  /// No description provided for @categoresSavedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل وسم بنجاح'**
  String get categoresSavedSuccessfully;

  /// No description provided for @todayEntries.
  ///
  /// In ar, this message translates to:
  /// **'مدخلات اليوم'**
  String get todayEntries;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
