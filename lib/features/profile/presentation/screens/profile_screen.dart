import 'package:chatify/features/settings/presentation/screens/settings_screen.dart';
import 'package:chatify/features/profile/presentation/cubit/edit_profile_info_cubit.dart';
import 'package:chatify/core/utils/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:chatify/core/widgets/custom_button.dart';
import 'package:chatify/core/widgets/custom_loading_indicator.dart';
import 'package:chatify/core/widgets/custom_text_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatify/core/theme/app_colors.dart';
import 'package:chatify/core/constants/app_strings.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = 'profilescreen';

  final String username;
  final String email;
  final String about;
  final String profilePhotoUrl;

  ProfileScreen({
    super.key,
    required this.username,
    required this.email,
    required this.about,
    required this.profilePhotoUrl,
  });

  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = username;
    aboutController.text = about;
    emailController.text = email;
    String intialName = username;
    String intialAbout = about;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.white,
          titleSpacing: 0,
          title: const Text(
            AppStrings.profile,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26),
          ),
          leading: const BackButton(
            color: AppColors.primary,
          ),
        ),
        body: BlocConsumer<EditProfileInfoCubit, EditProfileInfoState>(
          listener: (context, state) {
            if (state is EditProfileInfoError) {
              showSnackBar(context, state.error);
            }
            if (state is EditProfileInfoLoading) {
              showDialog(
                  context: context,
                  builder: (context) => const CustomLoadingIndicator(),
                  barrierDismissible: true);
            }
            if (state is EditProfileInfoSuccess) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context); // Close dialog
              }
              Navigator.pop(context);

              Navigator.popAndPushNamed(
                  context, SettingsScreen.routeName); // Redirect to settings
              showSnackBar(context, AppStrings.profileUpdated);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: (state is EditProfilePhotoSelected ||
                                        context
                                                .read<EditProfileInfoCubit>()
                                                .selectedImage !=
                                            null)
                                    ? Image.file(BlocProvider.of<
                                                EditProfileInfoCubit>(context)
                                            .selectedImage!)
                                        .image
                                    : (profilePhotoUrl.isNotEmpty)
                                        ? Image.network(profilePhotoUrl).image
                                        : Image.asset("assets/user.png").image,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(53),
                              border: Border.all(
                                color: AppColors.transparent,
                                width: 2,
                              )),
                        ),
                        InkWell(
                          onTap: () =>
                              BlocProvider.of<EditProfileInfoCubit>(context)
                                  .pickImage(),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.transparent,
                            backgroundImage: Image.asset(
                              "assets/pen_icon.png",
                              fit: BoxFit.fitWidth,
                            ).image,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 8),
                              child: RichText(
                                text: const TextSpan(
                                  text: AppStrings.nameLabel, // Default text
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AppColors.textPrimary, // Main text color
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '*', // Asterisk
                                      style: TextStyle(
                                        color:
                                            AppColors.error, // Make the asterisk red
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            CustomTextformField(
                              backgroundColor: AppColors.inputBackground,
                              bordercolor: AppColors.transparent,
                              controller: nameController,
                              validator: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return AppStrings.nameRequired;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 8),
                              child: RichText(
                                text: const TextSpan(
                                  text: AppStrings.aboutLabel, // Default text
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AppColors.textPrimary, // Main text color
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '*', // Asterisk
                                      style: TextStyle(
                                        color:
                                            AppColors.error, // Make the asterisk red
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            CustomTextformField(
                              backgroundColor: AppColors.inputBackground,
                              bordercolor: AppColors.transparent,
                              controller: aboutController,
                              validator: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return AppStrings.aboutRequired;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 8),
                              child: RichText(
                                text: const TextSpan(
                                  text: AppStrings.emailLabel, // Default text
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AppColors.textPrimary,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '*', // Asterisk
                                      style: TextStyle(
                                        color:
                                            AppColors.error, // Make the asterisk red
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            CustomTextformField(
                              backgroundColor: AppColors.inputBackground,
                              bordercolor: AppColors.transparent,
                              controller: emailController,
                              readonly: true,
                            ),
                          ]),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      text: AppStrings.save,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final cubit =
                              BlocProvider.of<EditProfileInfoCubit>(context);
                          if (intialName != nameController.text.trim() ||
                              intialAbout != aboutController.text.trim() &&
                                  state is EditProfilePhotoSelected) {
                            await cubit.editProfileImage();
                            await cubit.updateUserInfo(
                              name: nameController.text.trim(),
                              about: aboutController.text.trim(),
                            );
                          } else if (state is EditProfilePhotoSelected) {
                            await cubit.editProfileImage();
                          } else if (intialName != nameController.text.trim() ||
                              intialAbout != aboutController.text.trim()) {
                            await cubit.updateUserInfo(
                              name: nameController.text.trim(),
                              about: aboutController.text.trim(),
                            );
                          } else {
                            showSnackBar(context, AppStrings.noChangesFound);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
