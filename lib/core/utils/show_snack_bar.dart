import 'package:flutter/material.dart';
import 'package:chatify/core/theme/app_colors.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                content: Text(message),
                backgroundColor: AppColors.primary, // Custom theme color
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(8),
              ),
            );
  
}