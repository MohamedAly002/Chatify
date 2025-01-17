import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'edit_profile_info_state.dart';

class EditProfileInfoCubit extends Cubit<EditProfileInfoState> {
  EditProfileInfoCubit() : super(EditProfileInfoInitial());
  File? selectedImage;

  final supabase = Supabase.instance.client;

  Future<void> updateUserInfo(
      {required String name, required String about}) async {
    emit(EditProfileInfoLoading());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'username': name,
        'about': about,
      });
      emit(EditProfileInfoSuccess());
    } catch (e) {
      emit(
          EditProfileInfoError(error: 'Failed to update your information: $e'));
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        emit(EditProfilePhotoSelected());
      }
    } catch (e) {
      emit(
          EditProfileInfoError(error: 'Failed to pick image: ${e.toString()}'));
    }
  }

  Future<void> editProfileImage() async {
    if (selectedImage == null) {
      return;
    }

    emit(EditProfileInfoLoading());
    try {
      final firebaseUserId = FirebaseAuth.instance.currentUser?.uid;
      final previousPhotoUrl = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUserId)
          .get()
          .then((snapshot) => snapshot['profile_photo_url']);
      if (previousPhotoUrl != null) {
        final fileName = previousPhotoUrl.split('/').last;
        await supabase.storage.from('profile-photos').remove([fileName]);
      }
      final fileName =
          '$firebaseUserId-${DateTime.now().millisecondsSinceEpoch}.jpg';
      await supabase.storage.from('profile-photos').upload(
            fileName,
            selectedImage!,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final imageUrl =
          supabase.storage.from('profile-photos').getPublicUrl(fileName);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUserId)
          .update({
        'profile_photo_url': imageUrl,
      });
      selectedImage = null;
      emit(EditProfileInfoSuccess(imageUrl));
    } catch (e) {
      emit(EditProfileInfoError(error: 'An error occurred: $e'));
      log(e.toString());
    }
  }
}
