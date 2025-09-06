import 'package:mal/shared/data/models/user.dart';
import 'package:mal/shared/db.dart';

class SqlProvider {
  Future<User> storeUser(User user) async {
    final db = await Db.use();

    await db.insert('users', user.toMap());

    return user;
  }
}
