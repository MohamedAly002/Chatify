import 'package:chatify/Screens/privacypolicy_screen.dart';
import 'package:chatify/Screens/terms_conditions_screen.dart';
import 'package:chatify/cubit/welcome_screen_cubit/cubit/welcome_screen_cubit.dart';
import 'package:chatify/custom%20widgets/custom_button.dart';
import 'package:chatify/helper/home_switcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static const routeName = 'welcome-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Center the logo vertically on the screen
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/chatify_logo.png', // Replace with your logo asset
              height: 200,
            ),
          ),
          // The remaining widgets placed at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Widgets stick to the bottom
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                    height: 450), // Spacer to push content below the logo
                // Title Section
                const Text(
                  'Welcome to Chatify',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Description and Links
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    children: [
                      const TextSpan(text: 'Read our '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(color: Color(0xFF1A5EC6)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to Privacy Policy Screen
                            Navigator.pushNamed(
                                context, PrivacyPolicyScreen.routeName);
                          },
                      ),
                      const TextSpan(
                          text: '. Tap "Agree and Continue" to accept '),
                      TextSpan(
                        text: 'Terms of Services.',
                        style: const TextStyle(color: Color(0xFF1A5EC6)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to Terms and Conditions Screen
                            Navigator.pushNamed(
                                context, TermsAndConditionsScreen.routeName);
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                CustomButton(
                    text: 'Agree and Continue',
                    onPressed: () async {
    await BlocProvider.of<WelcomeScreenCubit>(context).setFirstLaunchComplete();
    // ignore: use_build_context_synchronously
    Navigator.popAndPushNamed(context, HomeSwitcher.routeName);
  },),

                // Agree and Continue Button
              ],
            ),
          ),
        ],
      ),
    );
  }
}