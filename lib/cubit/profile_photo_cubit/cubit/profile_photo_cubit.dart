import 'dart:io';
import 'package:chatify/cubit/profile_photo_cubit/cubit/profile_photo_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePhotoCubit extends Cubit<SelectPhotoState> {
  ProfilePhotoCubit() : super(ProfilePhotoInitial());
  File? selectedImage;
  final supabase = Supabase.instance.client;

  Future<void> pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        emit(ProfilePhotoSelected());
      }
    } catch (e) {
      emit(ProfilePhotoError(error: 'Failed to pick image: ${e.toString()}'));
    }
  }

  Future<void> uploadProfileImage() async {
    if (selectedImage == null) {
      emit(ProfilePhotoError(error: 'No image selected.'));
      return;
    }

    emit(ProfilePhotoUploading());
    try {
        final firebaseUserId = FirebaseAuth.instance.currentUser?.uid;

      
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
      emit(ProfilePhotoSuccess(profilePhotoUrl: imageUrl));
    } catch (e) {
      emit(ProfilePhotoError(error: 'An error occurred: $e'));
    }
  }


  
}
