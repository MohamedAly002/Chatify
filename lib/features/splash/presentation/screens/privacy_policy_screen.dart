import 'package:flutter/material.dart';
import 'package:chatify/core/theme/app_colors.dart';
import 'package:chatify/core/constants/app_strings.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const String routeName = 'privacypolicy';

  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          AppStrings.privacyPolicy,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: const BackButton(
          color: AppColors.primary,
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.privacyPolicyPlaceholder,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
