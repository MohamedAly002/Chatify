import 'package:chatify/cubit/forget_password_cubit/cubit/forget_password_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  Future<void> forgetPassword({required String email}) async {
    emit(ForgetPasswordLoading());
    try {
      
       await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(ForgetPasswordSuccess());
    } catch (e) {
      emit(ForgetPasswordError(e.toString()));
    }
  }
}
