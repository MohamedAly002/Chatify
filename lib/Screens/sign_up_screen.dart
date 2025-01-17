import 'package:chatify/Screens/select_photo_screen.dart';
import 'package:chatify/cubit/auth_cubit/auth_cubit.dart';
import 'package:chatify/cubit/auth_cubit/auth_states.dart';
import 'package:chatify/custom%20widgets/custom_button.dart';
import 'package:chatify/custom%20widgets/custom_loading_indicator.dart';
import 'package:chatify/custom%20widgets/custom_textformfield.dart';
import 'package:chatify/helper/show_snack_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = 'signup';
  SignUpScreen({super.key});

  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController userNameController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<AuthCubit, AuthStates>(listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
                context: context,
                builder: (context) => const CustomLoadingIndicator(),
                barrierDismissible: false);
          } else if (state is AuthSignUpSuccess) {
            if (Navigator.canPop(context)) Navigator.pop(context);
            Navigator.pop(context);
            Navigator.popAndPushNamed(context, SelectPhotoScreen.routeName);
            showSnackBar(context,
                'User Created Successfully. Please upload a profile photo.');
          } else if (state is AuthError) {
            Navigator.pop(context);
            showSnackBar(context, state.error);
          }
        }, builder: (context, state) {
          final authCubit = context.read<AuthCubit>();
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(children: [
                  Image.asset('assets/chatify_logo.png', height: 200),
                  const SizedBox(height: 10),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        CustomTextformField(
                          hint: 'Enter Your Username',
                          controller: userNameController,
                          keyboardtype: TextInputType.text,
                          prefixIcon: const Icon(Icons.person),
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please Enter Your Username';
                            }
                            return null;
                          },
                        ),
                        CustomTextformField(
                          controller: emailController,
                          hint: 'Enter Your Email',
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
                        CustomTextformField(
                          controller: passwordController,
                          hint: 'Enter Your Password',
                          keyboardtype: TextInputType.text,
                          isObsecured: authCubit.isSignUpPasswordVisible,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                authCubit.signUpPasswordVisibility();
                              },
                              icon: Icon(authCubit.isSignUpPasswordVisible
                                  ? CupertinoIcons.eye_slash_fill
                                  : CupertinoIcons.eye_fill)),
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please Enter Your Password';
                            }
                            if (text.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        CustomTextformField(
                          controller: confirmPasswordController,
                          hint: 'Confirm Your Password',
                          keyboardtype: TextInputType.text,
                          isObsecured: authCubit.isSignUpConfirmPasswordVisible,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                authCubit.signUpConfirmPasswordVisibility();
                              },
                              icon: Icon(
                                  authCubit.isSignUpConfirmPasswordVisible
                                      ? CupertinoIcons.eye_slash_fill
                                      : CupertinoIcons.eye_fill)),
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please Enter Your Password';
                            }
                            if (passwordController.text != text) {
                              return "Password doesn't match";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            onPressed: () {
                              if (formKey.currentState!.validate() &&
                                  passwordController.text.trim() ==
                                      confirmPasswordController.text.trim()) {
                                BlocProvider.of<AuthCubit>(context).signUp(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  username: userNameController.text.trim(),
                                );
                              }
                            },
                            text: 'Sign Up',
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Have an account ?",
                                  style: TextStyle(fontSize: 16)),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Sign In Now",
                                      style: TextStyle(
                                          color: Color(0xFF31C48D),
                                          fontSize: 16),
                                    )),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ]),
              )),
            ),
          );
        }));
  }
}
