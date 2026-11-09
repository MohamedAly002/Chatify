import 'package:flutter/material.dart';
import 'package:chatify/core/theme/app_colors.dart';
import 'package:chatify/core/constants/app_strings.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  static const String routeName = 'termsconditions';

  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: const BackButton(
          color: AppColors.primary,
        ),
        title: const Text(
          AppStrings.termsTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.termsPlaceholder,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
