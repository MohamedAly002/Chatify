import 'package:chatify/Screens/forget_password_screen.dart';
import 'package:chatify/Screens/home_screen.dart';
import 'package:chatify/Screens/sign_up_screen.dart';
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

class SignInScreen extends StatelessWidget {
  static const String routeName = 'signin';

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  SignInScreen({super.key});

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
        } else if (state is AuthSignInSuccess) {
          if (Navigator.canPop(context)) {
                    Navigator.pop(context); 
                  }
          Navigator.popAndPushNamed(context, HomeScreen.routeName);
        } else if (state is AuthError) {
          Navigator.pop(context);
          showSnackBar(context, 'invalid Email or Password');
        }
      }, builder: (context, state) {
        final authCubit = context.read<AuthCubit>();
        return SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Image.asset('assets/chatify_logo.png', height: 200),
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        'Join the Conversation',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        'Sign in to connect with your friends.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          CustomTextformField(
                            controller: passwordController,
                            hint: 'Enter Your Password',
                            keyboardtype: TextInputType.text,
                            isObsecured: authCubit.isSignInPasswordVisible,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                authCubit.signInPasswordVisibility();
                              },
                              icon: Icon(authCubit.isSignInPasswordVisible
                                  ? CupertinoIcons.eye_slash_fill
                                  : CupertinoIcons.eye_fill),
                            ),
                            validator: (text) {
                              if (text == null || text.trim().isEmpty) {
                                return 'Please Enter Your Password';
                              }

                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            child: const Text(
                              'Forget Password?',
                              style: TextStyle(color: Color(0xFF31C48D)),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ForgetPassword.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<AuthCubit>(context).signIn(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          }

                          // Handle sign-in action
                        },
                        text: 'Sign In',
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account ?",
                              style: TextStyle(fontSize: 16)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, SignUpScreen.routeName);
                                },
                                child: const Text(
                                  "SignUp",
                                  style: TextStyle(
                                      color: Color(0xFF31C48D), fontSize: 16),
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
