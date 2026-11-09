import 'package:chatify/core/utils/show_snack_bar.dart';
import 'package:chatify/core/widgets/custom_button.dart';
import 'package:chatify/core/widgets/custom_loading_indicator.dart';
import 'package:chatify/core/widgets/custom_text_form_field.dart';
import 'package:chatify/features/auth/presentation/views/sign_in_screen.dart';
import 'package:chatify/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:chatify/features/auth/presentation/cubit/forget_password_state.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatify/core/constants/app_strings.dart';

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
              AppStrings.passwordResetSent);
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
                    hint: AppStrings.enterYourEmail,
                    controller: emailController,
                    keyboardtype: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email),
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return AppStrings.pleaseEnterYourEmail;
                      }
                      if (!EmailValidator.validate(text) ||
                          !emailRegex.hasMatch(text)) {
                        return AppStrings.invalidEmailFormat;
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
                      text: AppStrings.resetPassword,
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
