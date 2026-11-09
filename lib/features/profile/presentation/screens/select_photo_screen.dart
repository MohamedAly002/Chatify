import 'package:chatify/features/home/presentation/screens/home_screen.dart';
import 'package:chatify/features/profile/presentation/cubit/profile_photo_cubit.dart';
import 'package:chatify/features/profile/presentation/cubit/profile_photo_state.dart';
import 'package:chatify/core/widgets/custom_loading_indicator.dart';
import 'package:chatify/core/utils/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatify/core/theme/app_colors.dart';
import 'package:chatify/core/constants/app_strings.dart';

class SelectPhotoScreen extends StatefulWidget {
  static const String routeName = 'SelectPhotoScreen';
  const SelectPhotoScreen({super.key});

  @override
  State<SelectPhotoScreen> createState() => _SelectPhotoScreenState();
}

class _SelectPhotoScreenState extends State<SelectPhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: AppColors.white,
          title: const Text(
            AppStrings.chooseProfilePicture,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.primary),
        ),
        body: BlocConsumer<ProfilePhotoCubit, SelectPhotoState>(
            listener: (context, state) {
          if (state is ProfilePhotoUploading) {
            showDialog(
                context: context,
                builder: (context) => const CustomLoadingIndicator(),
                barrierDismissible: false);
          }
          if (state is ProfilePhotoSuccess) {
            if (Navigator.canPop(context)) Navigator.pop(context);
            Navigator.pop(context);
            Navigator.popAndPushNamed(context, HomeScreen.routeName);
          }
          if (state is ProfilePhotoError) {
            Navigator.pop(context);
            showSnackBar(context, state.error);
          }
        }, builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // Profile Picture Display
                  Center(
                    child: CircleAvatar(
                      radius: 120,
                      backgroundColor: AppColors.transparent,
                      backgroundImage: state is ProfilePhotoSelected ||
                              state is ProfilePhotoUploading
                          ? FileImage(
                              BlocProvider.of<ProfilePhotoCubit>(context)
                                  .selectedImage!)
                          : Image.asset(
                              "assets/user.png",
                              fit: BoxFit.fill,
                            ).image,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Button to Choose Image
                  ElevatedButton.icon(
                    onPressed: () {
                      BlocProvider.of<ProfilePhotoCubit>(context).pickImage();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    icon: const Icon(Icons.photo_library, color: AppColors.textPrimary),
                    label: const Text(
                      AppStrings.chooseFromGallery,
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
              // Continue Button at the Bottom
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: ElevatedButton(
                  onPressed: state is ProfilePhotoSelected
                      ? () {
                          BlocProvider.of<ProfilePhotoCubit>(context)
                              .uploadProfileImage();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    AppStrings.continueLabel,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }));
  }
}
