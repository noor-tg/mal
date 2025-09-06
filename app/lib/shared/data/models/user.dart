import 'package:equatable/equatable.dart';
import 'package:mal/utils.dart';

class User extends Equatable {
  final String uid;
  final String name;
  final String? avatar;
  final bool biometricEnabled;
  final String pinHash;
  final String salt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  User({
    required this.name,
    required this.pinHash,
    required this.salt,
    String? uid,
    this.avatar,
    this.biometricEnabled = false,
    this.updatedAt,
    DateTime? createdAt,
  }) : uid = uid ?? uuid.v4(),
       createdAt = createdAt ?? DateTime.now();

  @override
  List<Object?> get props => [
    uid,
    avatar,
    biometricEnabled,
    name,
    pinHash,
    salt,
    createdAt,
    updatedAt,
  ];

  static User fromMap(Map<String, Object?> map) {
    return User(
      uid: map['uid'] as String,
      avatar: map['avatar'] as String?,
      biometricEnabled: (map['biometric_enabled'] as int) != 0,
      name: map['name'] as String,
      pinHash: map['pin_hash'] as String,
      salt: map['salt'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] == null
          ? null
          : DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'uid': uid,
      'avatar': avatar,
      'biometric_enabled': biometricEnabled ? 1 : 0,
      'name': name,
      'pin_hash': pinHash,
      'salt': salt,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
