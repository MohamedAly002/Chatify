import 'package:chatify/config/supabase_config.dart';
import 'package:chatify/core/constants/app_strings.dart';
import 'package:chatify/core/routes/app_routes.dart';
import 'package:chatify/core/theme/app_theme.dart';
import 'package:chatify/features/splash/presentation/cubit/welcome_screen_cubit.dart';
import 'package:chatify/features/splash/presentation/screens/splash_screen.dart';
import 'package:chatify/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    publishableKey: SupabaseConfig.supabasePublishableKey,
  );
  runApp(const MyApp());  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: AppTheme.light,
        home: BlocProvider(create: (_) => WelcomeScreenCubit(), child: const SplashScreen()),
        routes: appRoutes,
      );
}
