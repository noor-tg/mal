import 'package:equatable/equatable.dart';
import 'package:mal/utils.dart';

class Category extends Equatable {
  Category({
    required this.title,
    required this.type,
    required this.userUid,
    String? uid,
  }) : uid = uid ?? uuid.v4();

  final String uid;
  final String title;
  final String userUid;
  final String type;

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'title': title, 'type': type, 'user_uid': userUid};
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      uid: map['uid'] as String,
      title: map['title'] as String,
      type: map['type'] as String,
      userUid: map['user_uid'] as String,
    );
  }

  @override
  List<Object?> get props => [uid, title, type, userUid];
}
