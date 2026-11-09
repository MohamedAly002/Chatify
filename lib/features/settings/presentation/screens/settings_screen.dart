import 'package:chatify/features/home/presentation/screens/home_screen.dart';
import 'package:chatify/features/profile/presentation/screens/profile_screen.dart';
import 'package:chatify/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:chatify/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chatify/features/auth/presentation/cubit/auth_state.dart';
import 'package:chatify/features/profile/presentation/cubit/user_info_cubit.dart';
import 'package:chatify/features/profile/presentation/cubit/edit_profile_info_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatify/core/theme/app_colors.dart';
import 'package:chatify/core/constants/app_strings.dart';

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
            backgroundColor: AppColors.white,
            titleSpacing: 0,
            title: const Text(
              AppStrings.settings,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26),
            ),
            leading: BackButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (route) => false),
              color: AppColors.primary,
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
                              builder: (context) => BlocProvider(
                                create: (_) => EditProfileInfoCubit(),
                                child: ProfileScreen(
                                    username: (userInfoState as UserInfoLoaded)
                                        .username,
                                    email: (userInfoState).email,
                                    about: (userInfoState).about,
                                    profilePhotoUrl:
                                        (userInfoState).profilePhotoUrl,
                                    )))),
                              child: Row(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: AppColors.transparent,
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
                                      : AppStrings.username,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 23),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userInfoState is UserInfoLoaded
                                      ? userInfoState.email
                                      : AppStrings.email,
                                  style: const TextStyle(
                                      fontSize: 16, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userInfoState is UserInfoLoaded
                                      ? userInfoState.about
                                      : AppStrings.about,
                                  style: const TextStyle(
                                      fontSize: 16, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: AppColors.border,
                    thickness: 1,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.error.withOpacity(0.2),
                      child: Image.asset('assets/vector.png'),
                    ),
                    title: const Text(
                      AppStrings.logout,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.error),
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
