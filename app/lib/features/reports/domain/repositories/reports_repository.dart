import 'package:mal/features/reports/domain/entities/sums.dart';
import 'package:mal/features/reports/domain/entities/totals.dart';

abstract class ReportsRepository {
  Future<Totals> totals();
  Future<Sums> dailySums();
}
