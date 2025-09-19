import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:mal/shared/data/models/user.dart';
import 'package:mal/utils.dart';
import 'package:mal/utils/logger.dart';

abstract class UserRepository {
  Future<bool> register({required String name, required String pin});

  String generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64.encode(saltBytes);
  }

  // Hash PIN with salt
  String hashPin(String pin, String salt) {
    final saltBytes = base64.decode(salt);
    final pinBytes = utf8.encode(pin);
    final combined = [...saltBytes, ...pinBytes];
    final digest = sha256.convert(combined);
    return digest.toString();
  }

  Future<User?> verifyPin(String name, String pin) async {
    try {
      final db = await createOrOpenDB();
      final users = await db.query(
        'users',
        where: 'name = ?',
        whereArgs: [name],
      );

      logger
        ..i(users)
        ..i('printed users when verifyPin');
      if (users.isEmpty) {
        return null;
      }

      final user = users.first;
      final salt = user['salt'] as String;
      final storedHash = user['pin_hash'] as String;
      final inputHash = hashPin(pin, salt);

      if (inputHash == storedHash) {
        logger.i(user);
        return User.fromMap(user);
      }

      return null;
    } catch (e, trace) {
      logger
        ..e('Error verifying PIN: $e')
        ..t(trace);
      return null;
    }
  }

  Future<User> getUser(String uid);

  Future<bool> toggleBiometric(String name, bool enabled);

  Future<User?> getUserByName(String name);
}
