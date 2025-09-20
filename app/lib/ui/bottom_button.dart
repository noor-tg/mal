import 'package:flutter/material.dart';
import 'package:mal/mal_page.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({
    super.key,
    required this.pages,
    required this.index,
    required this.onPressed,
    required this.activeTab,
  });

  final List<MalPage> pages;
  final int index;
  final int activeTab;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: activeTab == index
            ? Theme.of(context).colorScheme.primary
            : Colors.grey.shade600,
      ),

      onPressed: onPressed,
      child: Column(
        children: [
          if (pages[index].icon != null && pages[index].icon is Icon)
            pages[index].icon!,
          if (pages[index].icon == null && pages[index].avatar is ImageProvider)
            CircleAvatar(
              radius: 12,
              backgroundImage: pages[index].avatar,
              backgroundColor: Colors.white,
            ),
          Text(pages[index].title),
        ],
      ),
    );
  }
}
