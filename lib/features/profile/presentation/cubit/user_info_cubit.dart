import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatify/core/constants/app_strings.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  UserInfoCubit() : super(UserInfoInitial());
  Future<void> fetchUserInfo() async {
  emit(UserInfoLoading());
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(UserInfoError(error: AppStrings.userNotAuthenticated));
      return;
    }

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      final data = userDoc.data();
      emit(UserInfoLoaded(
        username: data?['username'] ?? AppStrings.unknown,
        email: data?['email'] ?? AppStrings.noEmailProvided,
        profilePhotoUrl: data?['profile_photo_url'] ?? '',
        about: data?['about'] ?? AppStrings.available,
       
      ));
    } else {
      emit(UserInfoError(error: AppStrings.userInformationNotFound));
    }
  } catch (e) {
    emit(UserInfoError(error: '${AppStrings.failedToFetchUserInfo}$e'));
  }
}

}
