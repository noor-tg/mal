import 'package:mal/utils.dart';

class Category {
  Category({required this.title, required this.type, String? uid})
    : uid = uid ?? uuid.v4();

  String uid;
  final String title;
  final String type;
}
