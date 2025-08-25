import 'package:mal/utils.dart';

class Category {
  Category({required this.title, required this.type, String? uid})
    : uid = uid ?? uuid.v4();

  String uid;
  final String title;
  final String type;

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'title': title, 'type': type};
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      uid: map['uid'] as String,
      title: map['title'] as String,
      type: map['type'] as String,
    );
  }

  @override
  String toString() {
    return 'Category{uid: $uid, title: $title, type: $type}';
  }
}
