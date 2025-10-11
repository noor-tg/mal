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
  /// **'يجب إدخال 2 حروف على الاقل'**
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

  /// No description provided for @entriesCount.
  ///
  /// In ar, this message translates to:
  /// **'عدد المدخلات'**
  String get entriesCount;

  /// No description provided for @categoriesCount.
  ///
  /// In ar, this message translates to:
  /// **'عدد الوسوم'**
  String get categoriesCount;

  /// No description provided for @exportToCsv.
  ///
  /// In ar, this message translates to:
  /// **'تحميل البيانات'**
  String get exportToCsv;

  /// No description provided for @exportInProgress.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل'**
  String get exportInProgress;

  /// No description provided for @exportCompleted.
  ///
  /// In ar, this message translates to:
  /// **'تم إستخراج البيانات بنجاح'**
  String get exportCompleted;

  /// No description provided for @openFile.
  ///
  /// In ar, this message translates to:
  /// **'فتح الملف'**
  String get openFile;

  /// No description provided for @million.
  ///
  /// In ar, this message translates to:
  /// **'مـ'**
  String get million;

  /// No description provided for @thousand.
  ///
  /// In ar, this message translates to:
  /// **'أ'**
  String get thousand;

  /// No description provided for @skip.
  ///
  /// In ar, this message translates to:
  /// **'تخطي'**
  String get skip;

  /// No description provided for @start.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ'**
  String get start;

  /// No description provided for @help.
  ///
  /// In ar, this message translates to:
  /// **'مساعدة'**
  String get help;

  /// No description provided for @previous.
  ///
  /// In ar, this message translates to:
  /// **'السابق'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get next;

  /// No description provided for @lorem_ipsum.
  ///
  /// In ar, this message translates to:
  /// **' انطباع عن الشكل النهائي للمحتوى. نص لوريم إيبسوم باللغة العربية مشتق من نص لاتيني كتبه الفيلسوف الروماني شيشرون وقد تم استخدامه منذ ستينيات القرن العشرين. النص غير منطقي ولا ينقل أي معنى محدد، مما يسمح للمصممين بالتركيز على التخطيط والعناصر المرئية دون تشتيت الانتباه بالمحتوى الهادف. يعد النص المؤقت أمرًا بالغ الأهمية للمصممين لتصور التخطيطات دون تشتيت الانتباه عن المحتوى الحقيقي. فهو يسمح بالتركيز على الجماليات والبنية، مما يضمن عرضًا متوازنًا. يعزز التخطيط النظيف الإبداع ويسهل التجريب باستخدام الطباعة والألوان والتباعد. تعمل هذه الممارسة على تبسيط عملية التصميم وتساعد أصحاب المصلحة على تصور إمكانات المشروع.في المشاريع الإبداعية، يعد التخطيط أمرًا حيويًا للرسائل الفعالة. يتيح نص لوريم إيبسوم للمصممين تجربة عناصر مختلفة، مما يسمح لهم بالتركيز على التكوين دون تشتيت الانتباه عن محتوى معين. يساعد هذا النص المؤقت على تصور التفاعل بين النص والصور، مما يضمن منتجًا نهائيًا ممتعًا من الناحية الجمالية وعمليًا. كما يوفر للعملاء تمثيلًا ملموسًا لاتجاه التصميم، ومواءمة التوقعات وتشجيع ردود الفعل التعاونية. يعد أسلوب الطباعة أمرًا أساسيًا للتصميم الفعال، حيث يؤثر بشكل كبير على كيفية إدراك المحتوى. يتيح استخدام نص لوريم إيبسوم بأطوال وأنماط مختلفة للمصممين رؤية كيفية تفاعل الخطوط والأحجام المختلفة، مما يؤدي إلى إنشاء عروض تقديمية متماسكة بصريًا. على سبيل المثال، يؤدي إقران رأس الصفحة بخط غامق مع خط نص خافت إلى إنشاء تسلسل هرمي يوجه عين المشاهد. هذه التجربة ضرورية لتطوير التصميمات التي تعزز الجمالية وقابلية القراءة، مما يمكن المصممين من تحسين اختيارات أسلوب الطباعة الخاصة بهم لنقل نغمة المحتوى والرسالة المقصودة. يسمح استخدام نص لوريم إيبسوم في النص العربي للمصممين بترتيب العناصر بطريقة توجه عيون المشاهدين بشكل طبيعي عبر الصفحة. إنه يبسط موازنة الصور والمسافات البيضاء دون تشتيت الانتباه عن المحتوى الحقيقي، مما يعزز تجربة المستخدم النظيفة والجذابة. يضمن هذا النهج إبراز المعلومات المهمة مع الحفاظ على الجاذبية البصرية. بالإضافة إلى ذلك، فإنه يمكّن المصممين من تجربة تخطيطات وأنماط مختلفة دون قيود النص الحقيقي، مما يؤدي إلى حلول أكثر ابتكارًا تجذب الجمهور. يعد لوريم إيبسوم باللغة العربية أمرًا بالغ الأهمية في تصميم الويب لإنشاء تخطيطات سريعة الاستجابة تتكيف مع أحجام الشاشات المختلفة. فهو يساعد المصممين على محاكاة تدفق المحتوى وملاءمته، مما يضمن تجربة مستخدم سلسة. هذا أمر ضروري في المشهد الرقمي اليوم، حيث يصل المستخدمون إلى المحتوى على أجهزة مختلفة. يسمح اختبار التصميمات باستخدام نص وهمي بالتعرف المبكر على المشكلات المحتملة، مما يتيح إجراء تعديلات في الوقت المناسب تعمل على تحسين قابلية الاستخدام وإمكانية الوصول، مما يؤدي في النهاية إلى منتج نهائي أكثر صقلًا.'**
  String get lorem_ipsum;

  /// No description provided for @showCaseDescriptionNewEntry.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل مدخل جديد ، يمكنك إضافة رصيدك الحالي أولا'**
  String get showCaseDescriptionNewEntry;

  /// No description provided for @showCaseDescriptionThemeSwitcher.
  ///
  /// In ar, this message translates to:
  /// **'تغيير السملة نهاري / ليلي'**
  String get showCaseDescriptionThemeSwitcher;

  /// No description provided for @showCaseDescriptionUserProfile.
  ///
  /// In ar, this message translates to:
  /// **'ملف المستخدم'**
  String get showCaseDescriptionUserProfile;

  /// No description provided for @showCaseDescriptionBalanceCard.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد الحالي : فرق الدخل من المنصرفات'**
  String get showCaseDescriptionBalanceCard;

  /// No description provided for @showCaseDescriptionMonthReport.
  ///
  /// In ar, this message translates to:
  /// **'تقرير مجاميع المنصرفات و الدخل اليومي لهذا الشهر حتى اليوم'**
  String get showCaseDescriptionMonthReport;

  /// No description provided for @showCaseDescriptionPieReport.
  ///
  /// In ar, this message translates to:
  /// **'يمثل كل لون نسبة من القيمة الكلية ، والقائمة تحتوي على القيم الفعلية'**
  String get showCaseDescriptionPieReport;

  /// No description provided for @showCaseDescriptionTodayCard.
  ///
  /// In ar, this message translates to:
  /// **'مدخلات اليوم / إن أردت قائمة المدخلات السابقة راجع واجهة البحث ، إضغط على عنصر القائمة لعرض تفاصيل أكثر'**
  String get showCaseDescriptionTodayCard;

  /// No description provided for @showCaseDescriptionNewCategory.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل وسوم جديدة سيسهل عليك تصنيف بياناتك بسهولة لتحليل مصادر الدخل و مراكز المنصرفات'**
  String get showCaseDescriptionNewCategory;

  /// No description provided for @showCaseDescriptionCategoryList.
  ///
  /// In ar, this message translates to:
  /// **'هنا تجد قائمة الوسوم المسجلة ، مصنفة على حسب النوع، تستخدم هذه القائمة بشكل أساسي عن تسجيل أو تعديل مدخل، يمكنك. يمكنك سحب وسم للجانب لإخفاءه من قائمة الوسوم في إستمارة تسجيل مدخل'**
  String get showCaseDescriptionCategoryList;

  /// No description provided for @showCaseDescriptionClearBtn.
  ///
  /// In ar, this message translates to:
  /// **'لبدأ البحث من البداية'**
  String get showCaseDescriptionClearBtn;

  /// No description provided for @showCaseDescriptionFilterBtn.
  ///
  /// In ar, this message translates to:
  /// **'لإيجاد نتائج أكثر دقة يمكن إستخدام ادوات التصفية بضغط هذا الزر'**
  String get showCaseDescriptionFilterBtn;

  /// No description provided for @showCaseDescriptionSearchField.
  ///
  /// In ar, this message translates to:
  /// **'للبحث بالوصف أو الوسم أو النوع'**
  String get showCaseDescriptionSearchField;

  /// No description provided for @showCaseDescriptionSearchResults.
  ///
  /// In ar, this message translates to:
  /// **'كل نتائج البحث وعدد النتائج الكلي هنا ، يمكنك فتح تفاصيل أي مدخل عبر الضغط على العنصر المعين'**
  String get showCaseDescriptionSearchResults;

  /// No description provided for @showCaseDescriptionCalendarInfo.
  ///
  /// In ar, this message translates to:
  /// **'يمكن التبديل بين الشهور عبر الاسهم ، الضغط على زر \'أسبوع\' لتغيير عدد العناصر في التقويم ، الارقام بالاخضر مجموع دخل اليوم ، و الارقام بالاحمر منصرفات اليوم ، يمكنك الضغط على أي يوم لرؤية تفاصيله بالاسفل'**
  String get showCaseDescriptionCalendarInfo;

  /// No description provided for @showCaseDescriptionDayHeader.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ اليوم المختار من التقويم ، ورصيد اليوم ، إن كان بالاخضر فيعني الدخل اكثر من المنصرف'**
  String get showCaseDescriptionDayHeader;

  /// No description provided for @showCaseDescriptionDayList.
  ///
  /// In ar, this message translates to:
  /// **'قائمة مدخلات اليوم ، يمكن سحبها للأسفل لعرض عناصر أكثر'**
  String get showCaseDescriptionDayList;

  /// No description provided for @showCaseDescriptionAvatar.
  ///
  /// In ar, this message translates to:
  /// **'عرض صورة المستخدم في التطبيق أو تعديلها من المعرض أو الكاميرا'**
  String get showCaseDescriptionAvatar;

  /// No description provided for @showCaseDescriptionEditName.
  ///
  /// In ar, this message translates to:
  /// **'تعديل إسم المستخدم'**
  String get showCaseDescriptionEditName;

  /// No description provided for @showCaseDescriptionEditPin.
  ///
  /// In ar, this message translates to:
  /// **'تعديل رمز الدخول'**
  String get showCaseDescriptionEditPin;

  /// No description provided for @showCaseDescriptionBioToggle.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل أو إيقاف الدخول الحيوي للتطبيق بالبصمة أو الوجه'**
  String get showCaseDescriptionBioToggle;

  /// No description provided for @showCaseDescriptionDownloadData.
  ///
  /// In ar, this message translates to:
  /// **'تحميل بيانات المدخلات محلياً ، يمكنك بعدها عرض البيانات من أي برنامج يدعم excel'**
  String get showCaseDescriptionDownloadData;

  /// No description provided for @showCaseDescriptionLogoutBtn.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل خروج'**
  String get showCaseDescriptionLogoutBtn;
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
