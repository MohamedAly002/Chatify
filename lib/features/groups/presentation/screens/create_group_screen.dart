import 'package:chatify/features/groups/presentation/cubit/create_group_cubit.dart';
import 'package:chatify/core/widgets/custom_loading_indicator.dart';
import 'package:chatify/core/widgets/custom_text_form_field.dart';
import 'package:chatify/core/utils/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatify/core/theme/app_colors.dart';
import 'package:chatify/core/constants/app_strings.dart';

class CreateGroupScreen extends StatelessWidget {
  CreateGroupScreen({super.key});
  static const String routeName = 'create-group-screen';
  final TextEditingController groupNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    context.read<CreateGroupCubit>().resetState();
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: AppColors.white,
          title: const Text(
            AppStrings.createYourGroup,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          leading: const BackButton(
            color: AppColors.primary,
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.primary),
        ),
        body: BlocConsumer<CreateGroupCubit, CreateGroupState>(
            listener: (context, state) {
          if (state is CreateGroupLoading) {
            showDialog(
                context: context,
                builder: (context) => const CustomLoadingIndicator(),
                barrierDismissible: false);
          }
          if (state is CreateGroupSuccess) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context); // Close dialog
            }
            Navigator.pop(context);
          }
          if (state is CreateGroupError) {
            Navigator.pop(context);
            showSnackBar(context, state.errormessage);
          }
        }, builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [            
                Center(
                      child: CircleAvatar(
                        radius: 120,
                        backgroundColor: AppColors.transparent,
                        backgroundImage: state is GroupPhotoSelected ||state is CreateGroupLoading
                            ? FileImage(
                                BlocProvider.of<CreateGroupCubit>(context)
                                    .selectedImage!)
                            : Image.asset(
                                "assets/group_image.png",
                                fit: BoxFit.fill,
                              ).image,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Button to Choose Image
                    ElevatedButton.icon(
                      onPressed: () {
                        BlocProvider.of<CreateGroupCubit>(context).pickImage();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon:
                          const Icon(Icons.photo_library, color: AppColors.textPrimary),
                      label: const Text(
                        AppStrings.chooseFromGallery,
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Form(
                      key: formKey,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomTextformField(
                            controller: groupNameController,
                            hint: AppStrings.enterGroupName,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppStrings.pleaseEnterGroupName;
                              }
                              return null;
                            },
                            hasborder: false,
                          )),
                    ),
                // Continue Button at the Bottom
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate() &&
                          state is GroupPhotoSelected) {
                        BlocProvider.of<CreateGroupCubit>(context).addGroup(
                          groupNameController.text,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      AppStrings.createGroup,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
