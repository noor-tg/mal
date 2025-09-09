import 'package:flutter/material.dart';
import 'package:mal/constants.dart';

class MalPage {
  MalPage({
    required this.widget,
    required this.title,
    required this.actions,
    this.icon,
    FileImage? avatar,
  }) : avatar = avatar ?? const AssetImage(kAvatarPath);

  final String title;
  final Widget Function(Key? key) widget;
  final List<Widget> actions;

  Icon? icon;
  ImageProvider? avatar;
}
