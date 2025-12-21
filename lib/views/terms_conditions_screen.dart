import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  static const String routeName = 'termsconditions';

  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: const BackButton(
          color: Color(0xFF31C48D),
        ),
        title: const Text(
          'Terms & Conditions',
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
                'Here you can add the details of your terms & conditions...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
