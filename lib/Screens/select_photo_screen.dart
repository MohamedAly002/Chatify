import 'package:chatify/Screens/home_screen.dart';
import 'package:chatify/cubit/profile_photo_cubit/cubit/profile_photo_cubit.dart';
import 'package:chatify/cubit/profile_photo_cubit/cubit/profile_photo_state.dart';
import 'package:chatify/custom%20widgets/custom_loading_indicator.dart';
import 'package:chatify/helper/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Choose Profile Picture",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.teal),
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
                      backgroundColor: Colors.transparent,
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
                      backgroundColor: const Color(0xFF31C48D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    icon: const Icon(Icons.photo_library, color: Colors.black),
                    label: const Text(
                      "Choose from Gallery",
                      style: TextStyle(color: Colors.black),
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
                    backgroundColor: const Color(0xFF31C48D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
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
