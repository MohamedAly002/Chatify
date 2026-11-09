import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatify/core/constants/app_strings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'create_group_state.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  CreateGroupCubit() : super(CreateGroupInitial());
  File? selectedImage;
  final supabase = Supabase.instance.client;
  String? groupPhotoUrl;
  Future<void> pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        emit(GroupPhotoSelected());
      } else {
        emit(GroupPhotoError(errormessage: AppStrings.noImageSelected));
      }
    } catch (e) {
      emit(GroupPhotoError(
          errormessage: '${AppStrings.failedToPickImagePrefix}${e.toString()}'));
    }
  }

  Future<void> uploadImage(String groupId) async {
    if (selectedImage == null) {
      emit(GroupPhotoError(errormessage: AppStrings.noImageSelectedToUpload));
      return;
    }

    try {
      final fileName = '$groupId-${DateTime.now().millisecondsSinceEpoch}.jpg';
      await supabase.storage.from('group_photo').upload(
        fileName,
        selectedImage!,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      groupPhotoUrl =
          supabase.storage.from('group_photo').getPublicUrl(fileName);
    } catch (e) {
      emit(GroupPhotoError(
          errormessage: '${AppStrings.failedToUploadImage}${e.toString()}'));
    }
  }

  Future<void> addGroup(String groupName) async {
    emit(CreateGroupLoading());

    final groupId = FirebaseFirestore.instance.collection('groups').doc().id;

    try {
      await uploadImage(groupId);

      await FirebaseFirestore.instance.collection('groups').doc(groupId).set({
        'groupId': groupId,
        'groupName': groupName,
        'groupPhotoUrl': groupPhotoUrl,
        'CreatedAt': FieldValue.serverTimestamp(),
      });

      emit(CreateGroupSuccess());
    } catch (e) {
      emit(CreateGroupError(errormessage: '${AppStrings.failedToCreateGroupPrefix}$e'));
    }
  }
  void resetState() {
  selectedImage = null;
  groupPhotoUrl = null;
  emit(CreateGroupInitial());
}
}
