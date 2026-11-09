
import 'package:chatify/features/home/presentation/screens/home_screen.dart';
import 'package:chatify/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatify/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';

class HomeSwitcher extends StatelessWidget {
    static const String routeName = 'homeswitcher';

  const HomeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (builder,snapshot){
        if(snapshot.hasData){
          return const HomeScreen();
    }
        else{
          return BlocProvider(create: (_) => AuthCubit(), child: SignInScreen());
    }
    },
      ));
  }
}
