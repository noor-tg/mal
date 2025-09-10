import 'package:mal/features/reports/domain/entities/category_report.dart';
import 'package:mal/features/reports/domain/entities/sums.dart';
import 'package:mal/features/reports/domain/entities/totals.dart';

abstract class ReportsRepository {
  Future<Totals> totals(String userUid);
  Future<Sums> dailySums(String userUid);
  Future<List<CategoryReport>> getCategoriesPrecents(
    String type,
    String userUid,
  );
}
