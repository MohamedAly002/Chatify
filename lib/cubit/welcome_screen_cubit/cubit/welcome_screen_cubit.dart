import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'welcome_screen_state.dart';

class WelcomeScreenCubit extends Cubit<WelcomeScreenState> {
  WelcomeScreenCubit() : super(WelcomeScreenInitial());

  Future<void> checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    emit(WelcomeScreenNotfirsttime(isFirstLaunch: isFirstLaunch));
  }

  Future<void> setFirstLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
  }
}
