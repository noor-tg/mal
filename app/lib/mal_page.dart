import 'package:flutter/material.dart';
import 'package:mal/constants.dart';

class MalPage {
  MalPage({
    required this.widget,
    required this.title,
    this.action,
    this.icon,
    FileImage? avatar,
  }) : avatar = avatar ?? const AssetImage(kAvatarPath);

  final String title;
  final Widget? Function(Key? key) widget;
  final MalPageAction? action;

  Icon? icon;
  ImageProvider? avatar;
}

abstract class MalPageAction {
  void onPressed(BuildContext context);
}
