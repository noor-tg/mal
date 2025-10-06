import 'package:flutter/material.dart';

void errorPopup({required BuildContext context, required String message}) {
  popup(text: message, color: Colors.orange.shade900, context: context);
}

void successPopup({required BuildContext context, required String message}) {
  popup(text: message, color: Colors.green.shade900, context: context);
}

void popup({
  required Color color,
  required BuildContext context,
  required String text,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
    ),
  );
}
