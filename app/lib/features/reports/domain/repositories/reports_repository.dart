import 'package:mal/utils.dart';

abstract class ReportsRepository {
  Future<Totals> totals();
}
