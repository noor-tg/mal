// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/data.dart';
import 'package:mal/features/user/data/repositories/sql_repository.dart';
import 'package:mal/shared/data/models/user.dart';
import 'package:mal/test/unit_utils.dart';
import 'package:mal/utils.dart';

void main() {
  group('Users SQL Repository', () {
    setUpAll(() async {
      await GeneralSetup.init();
    });
    registerUserTest();
  });
}

void registerUserTest() {
  test('> register user', () async {
    // given
    final db = await createOrOpenDB();
    final repo = SqlRepository();
    final user = fakeUser();

    // when
    final success = await repo.register(
      name: user['name'] as String,
      pin: user['pin'] as String,
    );

    // then
    expect(success, isA<bool>());
    final storedUser = await db.query(
      'users',
      where: 'name = ?',
      whereArgs: [user['name']],
    );

    if (storedUser.isNotEmpty) {
      final userInfo = User.fromMap(storedUser.first);
      expect(userInfo.uid, isA<String>());
      expect(userInfo.name, isA<String>());
      expect(userInfo.pinHash, isA<String>());
      expect(userInfo.salt, isA<String>());
      expect(userInfo.avatar, isNull);
      expect(userInfo.createdAt, isA<DateTime>());
      expect(userInfo.updatedAt, isNull);
      expect(userInfo.name, user['name']);
    } else {
      throw Exception('user not found');
    }
  });
}
