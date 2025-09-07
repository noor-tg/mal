import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2), // space between border and avatar
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 8,
        ),
      ),
      child: const CircleAvatar(
        radius: 75,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/avatar.png'),
      ),
    );
  }
}
