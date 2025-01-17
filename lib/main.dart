import 'package:chatify/Keys/supabase%20key/supabase_config.dart';
import 'package:chatify/Screens/contacts_screen.dart';
import 'package:chatify/Screens/create_group_screen.dart';
import 'package:chatify/Screens/forget_password_screen.dart';
import 'package:chatify/Screens/select_photo_screen.dart';
import 'package:chatify/Screens/settings_screen.dart';
import 'package:chatify/Screens/sign_in_screen.dart';
import 'package:chatify/Screens/privacypolicy_screen.dart';
import 'package:chatify/Screens/sign_up_screen.dart';
import 'package:chatify/Screens/home_screen.dart';
import 'package:chatify/Screens/splash_screen.dart';
import 'package:chatify/Screens/terms_conditions_screen.dart';
import 'package:chatify/Screens/welcome_screen.dart';
import 'package:chatify/cubit/auth_cubit/auth_cubit.dart';
import 'package:chatify/cubit/create_group_cubit/cubit/create_group_cubit.dart';
import 'package:chatify/cubit/group_message_cubit/cubit/group_message_cubit.dart';
import 'package:chatify/cubit/chat_message_cubit/chat_message_cubit.dart';
import 'package:chatify/cubit/forget_password_cubit/cubit/forget_password_cubit.dart';
import 'package:chatify/cubit/profile_photo_cubit/cubit/profile_photo_cubit.dart';
import 'package:chatify/cubit/update_profile_info_cubit/cubit/edit_profile_info_cubit.dart';
import 'package:chatify/cubit/user_chatList_cubit/cubit/user_chatList_cubit.dart';
import 'package:chatify/cubit/group_list_cubit/cubit/group_list_cubit.dart';
import 'package:chatify/cubit/user_info_cubit/cubit/user_info_cubit.dart';
import 'package:chatify/cubit/users_list_cubit/users_list_cubit.dart';
import 'package:chatify/cubit/welcome_screen_cubit/cubit/welcome_screen_cubit.dart';
import 'package:chatify/helper/home_switcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl, anonKey: SupabaseConfig.supabaseApiKey);
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => ForgetPasswordCubit()),
    BlocProvider(
      create: (context) => AuthCubit(),
    ),
    BlocProvider(create: (context) => WelcomeScreenCubit()),
    BlocProvider(create: ((context) => ProfilePhotoCubit())),
    BlocProvider(create: (context) => UserInfoCubit()),
    BlocProvider(create: (context) => UsersListCubit()),
    BlocProvider(create: (context) => ChatMessageCubit()),
    BlocProvider(create: (context) => EditProfileInfoCubit()),
    BlocProvider(create: (context) => UserChatsCubit()),
    BlocProvider(create: (context) => CreateGroupCubit()),
    BlocProvider(create: (context) => GroupListCubit()),
    BlocProvider(create: (context) => GroupMessageCubit())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chatify',
        home: const SplashScreen(),
        routes: {
          SignInScreen.routeName: (_) => SignInScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),
          WelcomeScreen.routeName: (_) => const WelcomeScreen(),
          PrivacyPolicyScreen.routeName: (_) => const PrivacyPolicyScreen(),
          TermsAndConditionsScreen.routeName: (_) =>
              const TermsAndConditionsScreen(),
          SelectPhotoScreen.routeName: (_) => const SelectPhotoScreen(),
          SignUpScreen.routeName: (_) => SignUpScreen(),
          HomeSwitcher.routeName: (_) => const HomeSwitcher(),
          ForgetPassword.routeName: (_) => const ForgetPassword(),
          SettingsScreen.routeName: (_) => const SettingsScreen(),
          ContactsScreen.routeName: (_) => const ContactsScreen(),
          CreateGroupScreen.routeName: (_) => CreateGroupScreen(),
        });
  }
}
