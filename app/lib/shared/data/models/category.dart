import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({required this.title, required this.userUid, this.type = ''});

  final String title;
  final String userUid;
  final String type;

  Map<String, dynamic> toMap() {
    return {'title': title, 'type': type, 'user_uid': userUid};
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      title: map['title'] as String,
      type: map['type'] as String,
      userUid: map['user_uid'] as String,
    );
  }

  @override
  List<Object?> get props => [title, type, userUid];
}
