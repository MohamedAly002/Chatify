import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                content: Text(message),
                backgroundColor: const Color(0xFF31C48D), // Custom theme color
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(8),
              ),
            );
  
}