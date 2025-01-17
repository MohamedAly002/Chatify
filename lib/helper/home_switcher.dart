
import 'package:chatify/Screens/home_screen.dart';
import 'package:chatify/Screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          return SignInScreen();
    }
    },
      ));
  }
}
