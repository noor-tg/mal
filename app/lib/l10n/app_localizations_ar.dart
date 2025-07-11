// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get reportsTitle => 'تقارير';

  @override
  String get tabReportsLabel => 'تقارير';

  @override
  String get tabCalendarLabel => 'تقوم';

  @override
  String get tabSearchLabel => 'بحث';

  @override
  String get tabCategoriesLabel => 'وسوم';

  @override
  String get reportsBalance => 'الرصيد';

  @override
  String get expenses => 'المنصرفات';

  @override
  String get income => 'الدخل';

  @override
  String get newCategory => 'إضافة وسم';

  @override
  String get categoryTitle => 'العنوان';

  @override
  String get categoryType => 'النوع';

  @override
  String get save => 'حفظ';

  @override
  String get expense => 'منصرف';

  @override
  String get cancel => 'إلغاء';

  @override
  String get categoryTitleErrorMessage =>
      'يرجى إدخال العنوان بقيمة حرفين على الاقل';

  @override
  String get pleaseAddCorrectInfo => 'يرجى إدخال النوع و العنوان';

  @override
  String get categoryTypeErrorMessage => 'يرجى إختيار النوع';

  @override
  String get emptyCategoriesList => 'لا يوجد وسوم م مضافة';
}
