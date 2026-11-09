import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:chatify/features/splash/presentation/screens/welcome_screen.dart';
import 'package:chatify/features/splash/presentation/cubit/welcome_screen_cubit.dart';
import 'package:chatify/core/navigation/home_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatify/core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
  super.initState();
  context.read<WelcomeScreenCubit>().checkFirstLaunch();
}
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WelcomeScreenCubit, WelcomeScreenState>(
      builder: (context, state) {
        
        return FlutterSplashScreen.fadeIn(
          backgroundColor: AppColors.white,
          animationDuration: const Duration(milliseconds: 4000),
          duration: const Duration(milliseconds: 4200),
          childWidget: SizedBox(
            height: 200,
            width: 200,
            child: Image.asset("assets/chatify_logo.png"),
          ),
          nextScreen:state is WelcomeScreenNotfirsttime && state.isFirstLaunch? const WelcomeScreen(): const HomeSwitcher(),
        );
      },
    );
  }
}
