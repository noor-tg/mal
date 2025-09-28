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

  /// No description provided for @reportsTitle.
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
  /// **'تقويم'**
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

  /// No description provided for @title.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get title;

  /// No description provided for @categoryType.
  ///
  /// In ar, this message translates to:
  /// **'النوع'**
  String get categoryType;

  /// No description provided for @type.
  ///
  /// In ar, this message translates to:
  /// **'النوع'**
  String get type;

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

  /// No description provided for @editEntry.
  ///
  /// In ar, this message translates to:
  /// **'تعديل مدخل'**
  String get editEntry;

  /// No description provided for @amountErrorMessage.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال قيمة أكثر من 0'**
  String get amountErrorMessage;

  /// No description provided for @entrySavedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ المدخل بنجاح'**
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

  /// No description provided for @currentMonth.
  ///
  /// In ar, this message translates to:
  /// **'الشهر الحالي'**
  String get currentMonth;

  /// No description provided for @noDataFound.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد بيانات'**
  String get noDataFound;

  /// No description provided for @description.
  ///
  /// In ar, this message translates to:
  /// **'وصف'**
  String get description;

  /// No description provided for @date.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get date;

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'منصرف ، ملابس ، ملاحظة .. إلخ'**
  String get searchHint;

  /// No description provided for @noMoreData.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد بيانات إضافية'**
  String get noMoreData;

  /// No description provided for @searchTitleResults.
  ///
  /// In ar, this message translates to:
  /// **'نتائج البحث'**
  String get searchTitleResults;

  /// No description provided for @advancedSearch.
  ///
  /// In ar, this message translates to:
  /// **'بحث متقدم'**
  String get advancedSearch;

  /// No description provided for @categories.
  ///
  /// In ar, this message translates to:
  /// **'الوسوم'**
  String get categories;

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get all;

  /// No description provided for @order.
  ///
  /// In ar, this message translates to:
  /// **'الترتيب'**
  String get order;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @reset.
  ///
  /// In ar, this message translates to:
  /// **'تراجع'**
  String get reset;

  /// No description provided for @notSelected.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم الاختيار'**
  String get notSelected;

  /// No description provided for @entryRemovedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم الحذف بنجاح'**
  String get entryRemovedSuccessfully;

  /// No description provided for @entries.
  ///
  /// In ar, this message translates to:
  /// **'مدخلات'**
  String get entries;

  /// No description provided for @logo.
  ///
  /// In ar, this message translates to:
  /// **'مال'**
  String get logo;

  /// No description provided for @userName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get userName;

  /// No description provided for @clear.
  ///
  /// In ar, this message translates to:
  /// **'مسح'**
  String get clear;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'رمز المرور'**
  String get password;

  /// No description provided for @haveAnAccount.
  ///
  /// In ar, this message translates to:
  /// **'لديك حساب ؟ سجل دخول'**
  String get haveAnAccount;

  /// No description provided for @registerUser.
  ///
  /// In ar, this message translates to:
  /// **'حساب جديد'**
  String get registerUser;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل دخول'**
  String get login;

  /// No description provided for @notHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب ؟ أنشئ حساب'**
  String get notHaveAccount;

  /// No description provided for @registerBtn.
  ///
  /// In ar, this message translates to:
  /// **'سجل'**
  String get registerBtn;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'ملف المستخدم'**
  String get profile;

  /// No description provided for @member_since.
  ///
  /// In ar, this message translates to:
  /// **'عضو منذ'**
  String get member_since;

  /// No description provided for @updatedAt.
  ///
  /// In ar, this message translates to:
  /// **'أخر تحديث'**
  String get updatedAt;

  /// No description provided for @biometricEnabled.
  ///
  /// In ar, this message translates to:
  /// **'دخول الحيوي'**
  String get biometricEnabled;

  /// No description provided for @enabled.
  ///
  /// In ar, this message translates to:
  /// **'مفعل'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In ar, this message translates to:
  /// **'موقوف'**
  String get disabled;

  /// No description provided for @personalInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات أساسية'**
  String get personalInfo;

  /// No description provided for @editName.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الاسم'**
  String get editName;

  /// No description provided for @editPin.
  ///
  /// In ar, this message translates to:
  /// **'تعديل رمز المرور'**
  String get editPin;

  /// No description provided for @selectSource.
  ///
  /// In ar, this message translates to:
  /// **'إختر مصدر الصورة'**
  String get selectSource;

  /// No description provided for @selectCamera.
  ///
  /// In ar, this message translates to:
  /// **'الكاميرا'**
  String get selectCamera;

  /// No description provided for @selectGallery.
  ///
  /// In ar, this message translates to:
  /// **'معرض الصور'**
  String get selectGallery;

  /// No description provided for @profileLabel.
  ///
  /// In ar, this message translates to:
  /// **'المستخدم'**
  String get profileLabel;

  /// No description provided for @entry.
  ///
  /// In ar, this message translates to:
  /// **'مدخل'**
  String get entry;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل خروج'**
  String get logout;

  /// No description provided for @selectCorrectCategoryMessage.
  ///
  /// In ar, this message translates to:
  /// **'يجب إختيار وسم'**
  String get selectCorrectCategoryMessage;

  /// No description provided for @entryDescriptionErrorMessage.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن يكون الوصف بين 2 حرف إلي 255'**
  String get entryDescriptionErrorMessage;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @loginNameErrorMessage.
  ///
  /// In ar, this message translates to:
  /// **'يجب إدخال 4 حروف على الاقل'**
  String get loginNameErrorMessage;

  /// No description provided for @pinErrorMessage.
  ///
  /// In ar, this message translates to:
  /// **'يجب إدخل رمز 4 أرقام'**
  String get pinErrorMessage;

  /// No description provided for @loginErrorMessage.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال بيانات صحيحة'**
  String get loginErrorMessage;

  /// No description provided for @loginMessageSelectUser.
  ///
  /// In ar, this message translates to:
  /// **'يجب إختيار مستخدم أولا'**
  String get loginMessageSelectUser;

  /// No description provided for @registerUserAlreadyExist.
  ///
  /// In ar, this message translates to:
  /// **'المستخدم موجود مسبقاً'**
  String get registerUserAlreadyExist;

  /// No description provided for @registerSuccessLoginFailed.
  ///
  /// In ar, this message translates to:
  /// **'تم التسجيل ، يرجى تسجيل الدخول'**
  String get registerSuccessLoginFailed;

  /// No description provided for @registerFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل تسجيل المستخدم'**
  String get registerFailed;

  /// No description provided for @bioButton.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل دخول حيوي'**
  String get bioButton;

  /// No description provided for @bioLoginNotEnabled.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول الحيوي غير متوفر لهذا المستخدم'**
  String get bioLoginNotEnabled;

  /// No description provided for @loginLastUserNotFound.
  ///
  /// In ar, this message translates to:
  /// **'المستخدم غير موجود'**
  String get loginLastUserNotFound;
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
