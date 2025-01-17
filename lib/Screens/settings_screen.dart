import 'package:chatify/Screens/home_screen.dart';
import 'package:chatify/Screens/profile_screen.dart';
import 'package:chatify/Screens/sign_in_screen.dart';
import 'package:chatify/cubit/auth_cubit/auth_cubit.dart';
import 'package:chatify/cubit/auth_cubit/auth_states.dart';
import 'package:chatify/cubit/user_info_cubit/cubit/user_info_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = 'settings';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserInfoCubit>(context).fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, authState) {
        if (authState is AuthSignOutSuccess) {
          Navigator.pushNamedAndRemoveUntil(
              context, SignInScreen.routeName, (route) => false);
        } else if (authState is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authState.error)),
          );
        }
      },
      builder: (context, authState) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            titleSpacing: 0,
            title: const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26),
            ),
            leading: BackButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (route) => false),
              color: Color(0xFF31C48D),
            ),
          ),
          body: BlocConsumer<UserInfoCubit, UserInfoState>(
            listener: (context, userInfoState) {
              if (userInfoState is UserInfoError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(userInfoState.error)),
                );
              }
            },
            builder: (context, userInfoState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                    username: (userInfoState as UserInfoLoaded)
                                        .username,
                                    email: (userInfoState).email,
                                    about: (userInfoState).about,
                                    profilePhotoUrl:
                                        (userInfoState).profilePhotoUrl,
                                  ))),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.transparent,
                            backgroundImage: userInfoState is UserInfoLoaded
                                ? Image.network(userInfoState.profilePhotoUrl)
                                    .image
                                : Image.asset(
                                    "assets/user.png",
                                    fit: BoxFit.fill,
                                  ).image,
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userInfoState is UserInfoLoaded
                                      ? userInfoState.username
                                      : 'Username',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 23),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userInfoState is UserInfoLoaded
                                      ? userInfoState.email
                                      : 'Email',
                                  style: const TextStyle(
                                      fontSize: 16, color: Color(0xFF282A2D)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userInfoState is UserInfoLoaded
                                      ? userInfoState.about
                                      : 'About',
                                  style: const TextStyle(
                                      fontSize: 16, color: Color(0xFF282A2D)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: Color(0xFFEBEEF2),
                    thickness: 1,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFFF1843).withOpacity(0.2),
                      child: Image.asset('assets/vector.png'),
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xFFFF1843)),
                    ),
                    onTap: () {
                      context.read<AuthCubit>().signOut();
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
