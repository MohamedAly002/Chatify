import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  UserInfoCubit() : super(UserInfoInitial());
  Future<void> fetchUserInfo() async {
  emit(UserInfoLoading());
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(UserInfoError(error: 'User not authenticated.'));
      return;
    }

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      final data = userDoc.data();
      emit(UserInfoLoaded(
        username: data?['username'] ?? 'Unknown',
        email: data?['email'] ?? 'No email provided',
        profilePhotoUrl: data?['profile_photo_url'] ?? '',
        about:data?['about'] ?? 'Available',
       
      ));
    } else {
      emit(UserInfoError(error: 'User information not found.'));
    }
  } catch (e) {
    emit(UserInfoError(error: 'Failed to fetch user info: $e'));
  }
}

}
