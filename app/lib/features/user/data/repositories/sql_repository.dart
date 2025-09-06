import 'package:mal/features/user/data/sources/sql_provider.dart';
import 'package:mal/features/user/domain/repositories/user_repository.dart';
import 'package:mal/shared/data/models/user.dart';
import 'package:mal/shared/query_builder.dart';

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
}
