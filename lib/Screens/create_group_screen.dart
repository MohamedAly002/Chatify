import 'package:chatify/cubit/create_group_cubit/cubit/create_group_cubit.dart';
import 'package:chatify/custom%20widgets/custom_loading_indicator.dart';
import 'package:chatify/custom%20widgets/custom_textformfield.dart';
import 'package:chatify/helper/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateGroupScreen extends StatelessWidget {
  CreateGroupScreen({super.key});
  static const String routeName = 'create-group-screen';
  final TextEditingController groupNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    context.read<CreateGroupCubit>().resetState();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Create your Group",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          leading: const BackButton(
            color: Color(0xFF31C48D),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.teal),
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
                        backgroundColor: Colors.transparent,
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
                        backgroundColor: const Color(0xFF31C48D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon:
                          const Icon(Icons.photo_library, color: Colors.black),
                      label: const Text(
                        "Choose from Gallery",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Form(
                      key: formKey,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomTextformField(
                            controller: groupNameController,
                            hint: "Enter Group Name",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter group name";
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
                      backgroundColor: const Color(0xFF31C48D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      "Create Group",
                      style: TextStyle(
                        color: Colors.white,
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
