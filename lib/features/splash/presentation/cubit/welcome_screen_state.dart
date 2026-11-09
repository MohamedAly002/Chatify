part of 'welcome_screen_cubit.dart';

sealed class WelcomeScreenState {}

final class WelcomeScreenInitial extends WelcomeScreenState {}

final class WelcomeScreenfirsttime extends WelcomeScreenState {
 
}

final class WelcomeScreenNotfirsttime extends WelcomeScreenState {
  final bool isFirstLaunch;
  WelcomeScreenNotfirsttime({required this.isFirstLaunch});
}



