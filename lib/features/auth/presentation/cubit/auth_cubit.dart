import 'package:chatify/features/auth/presentation/cubit/auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatify/core/constants/app_strings.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isSignInPasswordVisible = true;
  bool isSignUpPasswordVisible = true;
  bool isSignUpConfirmPasswordVisible = true;
  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthSignInSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthError(AppStrings.noUserFoundForEmail));
      } else if (e.code == 'wrong-password') {
        emit(AuthError(AppStrings.wrongPassword));
      } else {
        emit(AuthError(e.code));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp(
      {required email,
      required String password,
      required String username}) async {
    emit(AuthLoading());
    try {
      // Create user in Firebase Auth
      final userCredential= await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
       final userId = userCredential.user!.uid;

      // Save username and other details in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({
        'id': userId,
        'username': username,
        'email': email,
        'createdAt': DateTime.now().toIso8601String(),
        'profile_photo_url': null,
        'about': AppStrings.available,
      });

      emit(AuthSignUpSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthError(AppStrings.weakPassword));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthError(AppStrings.accountAlreadyExists));
      } else {
        emit(AuthError(e.code));
      }
    }
  }
  Future<void> signOut() async {
  emit(AuthLoading()); // Show loading state during sign-out
  try {
    await auth.signOut();
    emit(AuthSignOutSuccess()); // Emit success state
  } catch (e) {
    emit(AuthError('${AppStrings.failedToSignOutPrefix}$e')); // Emit error state
  }
}

  void signInPasswordVisibility() {
    isSignInPasswordVisible = !isSignInPasswordVisible;
    emit(AuthPasswordVisibility());
  }

  void signUpPasswordVisibility() {
    isSignUpPasswordVisible = !isSignUpPasswordVisible;
    emit(AuthPasswordVisibility());
  }

  void signUpConfirmPasswordVisibility() {
    isSignUpConfirmPasswordVisible = !isSignUpConfirmPasswordVisible;
    emit(AuthPasswordVisibility());
  }
}
