import 'package:chatify/core/navigation/home_switcher.dart';
import 'package:chatify/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chatify/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:chatify/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:chatify/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:chatify/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:chatify/features/profile/presentation/cubit/profile_photo_cubit.dart';
import 'package:chatify/features/groups/presentation/cubit/create_group_cubit.dart';
import 'package:chatify/features/contacts/presentation/cubit/users_list_cubit.dart';
import 'package:chatify/features/profile/presentation/cubit/user_info_cubit.dart';
import 'package:chatify/features/splash/presentation/cubit/welcome_screen_cubit.dart';
import 'package:chatify/features/splash/presentation/screens/privacy_policy_screen.dart';
import 'package:chatify/features/splash/presentation/screens/terms_conditions_screen.dart';
import 'package:chatify/features/splash/presentation/screens/welcome_screen.dart';
import 'package:chatify/features/contacts/presentation/screens/contacts_screen.dart';
import 'package:chatify/features/groups/presentation/screens/create_group_screen.dart';
import 'package:chatify/features/home/presentation/screens/home_screen.dart';
import 'package:chatify/features/profile/presentation/screens/select_photo_screen.dart';
import 'package:chatify/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Map<String, WidgetBuilder> get appRoutes => {
  SignInScreen.routeName: (_) => BlocProvider(create: (_) => AuthCubit(), child: SignInScreen()),
  SignUpScreen.routeName: (_) => BlocProvider(create: (_) => AuthCubit(), child: SignUpScreen()),
  ForgetPassword.routeName: (_) => BlocProvider(create: (_) => ForgetPasswordCubit(), child: const ForgetPassword()),
  WelcomeScreen.routeName: (_) => BlocProvider(create: (_) => WelcomeScreenCubit(), child: const WelcomeScreen()),
  PrivacyPolicyScreen.routeName: (_) => const PrivacyPolicyScreen(),
  TermsAndConditionsScreen.routeName: (_) => const TermsAndConditionsScreen(),
  SelectPhotoScreen.routeName: (_) => BlocProvider(create: (_) => ProfilePhotoCubit(), child: const SelectPhotoScreen()),
  HomeScreen.routeName: (_) => const HomeScreen(),
  HomeSwitcher.routeName: (_) => const HomeSwitcher(),
  SettingsScreen.routeName: (_) => BlocProvider(create: (_) => AuthCubit(), child:
    BlocProvider(create: (_) => UserInfoCubit(), child: const SettingsScreen())),
  ContactsScreen.routeName: (_) => BlocProvider(create: (_) => UsersListCubit(), child: const ContactsScreen()),
  CreateGroupScreen.routeName: (_) => BlocProvider(create: (_) => CreateGroupCubit(), child: CreateGroupScreen()),
};
