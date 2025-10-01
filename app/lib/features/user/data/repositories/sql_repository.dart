import 'package:mal/features/user/data/sources/sql_provider.dart';
import 'package:mal/features/user/domain/entities/statistics.dart';
import 'package:mal/features/user/domain/repositories/user_repository.dart';
import 'package:mal/shared/data/models/user.dart';
import 'package:mal/shared/query_builder.dart';
import 'package:mal/utils.dart';
import 'package:mal/utils/logger.dart';

class SqlRepository extends UserRepository {
  final sqlProvider = SqlProvider();
  @override
  Future<bool> register({required String name, required String pin}) async {
    final salt = generateSalt();
    final hashed = hashPin(pin, salt);

    final user = await QueryBuilder('users').where('name', '=', name).getOne();
    if (user != null) {
      return false;
    }

    await sqlProvider.storeUser(User(name: name, pinHash: hashed, salt: salt));

    return true;
  }

  @override
  Future<User> getUser(String uid) async {
    final user = await QueryBuilder('users').where('uid', '=', uid).getOne();

    if (user == null) {
      throw Exception('not found');
    }

    return User.fromMap(user);
  }

  @override
  Future<bool> toggleBiometric(String name, bool enabled) async {
    try {
      final db = await createOrOpenDB();
      await db.update(
        'users',
        {'biometric_enabled': enabled ? 1 : 0},
        where: 'name = ?',
        whereArgs: [name],
      );
      return true;
    } catch (e) {
      logger.e('Error setting biometric: $e');
      return false;
    }
  }

  @override
  Future<User?> getUserByName(String name) async {
    final user = await QueryBuilder('users').where('name', '=', name).getOne();
    if (user == null) {
      return null;
    }

    return User.fromMap(user);
  }

  @override
  Future<Statistics> userStatistics(String uid) async {
    final entries = await QueryBuilder(
      'entries',
    ).where('user_uid', '=', uid).count();

    final categories = await QueryBuilder(
      'categories',
    ).where('user_uid', '=', uid).count();

    return Statistics(entries: entries, categories: categories);
  }
}
