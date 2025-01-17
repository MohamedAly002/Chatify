import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const String routeName = 'privacypolicy';

  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: const BackButton(
          color: Color(0xFF31C48D),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Here you can add the details of your privacy policy...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
