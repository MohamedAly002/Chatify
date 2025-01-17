import 'package:chatify/Screens/sign_in_screen.dart';
import 'package:chatify/cubit/forget_password_cubit/cubit/forget_password_cubit.dart';
import 'package:chatify/cubit/forget_password_cubit/cubit/forget_password_state.dart';
import 'package:chatify/custom%20widgets/custom_button.dart';
import 'package:chatify/custom%20widgets/custom_loading_indicator.dart';
import 'package:chatify/custom%20widgets/custom_textformfield.dart';
import 'package:chatify/helper/show_snack_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});
  static const String routeName = 'ForgetPassword';

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return Scaffold(
      body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {
        if (state is ForgetPasswordLoading) {
          showDialog(
              context: context,
              builder: (context) => const CustomLoadingIndicator(),
              barrierDismissible: false);
        }
        if (state is ForgetPasswordSuccess) {
          showSnackBar(context,
              'Code was sent to your email.\nplease Check your Email to reset passwaord');
          Navigator.popAndPushNamed(context, SignInScreen.routeName);
        } else if (state is ForgetPasswordError) {
          Navigator.pop(context);
          showSnackBar(context, state.error);
        }
      }, builder: (context, state) {
        final forgetPasswordCubit = context.read<ForgetPasswordCubit>();
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  Image.asset('assets/chatify_logo.png', height: 200),
                  const SizedBox(height: 40),
                  CustomTextformField(
                    hint: 'Enter Your Email',
                    controller: emailController,
                    keyboardtype: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email),
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter Your Email';
                      }
                      if (!EmailValidator.validate(text) ||
                          !emailRegex.hasMatch(text)) {
                        return 'Invalid Email Format';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: () {
                        forgetPasswordCubit.forgetPassword(
                            email: emailController.text);
                      },
                      text: 'Reset Password',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
