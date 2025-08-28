import 'package:mal/utils.dart';

class SqlProvider {
  Future<int> incomesTotal() async {
    final db = await createOrOpenDB();

    final incomes = await db.query(
      'entries',
      columns: ['sum(amount) as sum', 'type'],
      where: 'type = ?',
      whereArgs: ['دخل'],
      groupBy: '"type"',
    );

    return incomes.isNotEmpty ? incomes.first['sum'] as int : 0;
  }

  Future<int> expensesTotal() async {
    final db = await createOrOpenDB();

    final expenses = await db.query(
      'entries',
      columns: ['sum(amount) as sum', 'type'],
      where: 'type = ?',
      whereArgs: ['منصرف'],
      groupBy: '"type"',
    );

    return expenses.isNotEmpty ? expenses.first['sum'] as int : 0;
  }
}
