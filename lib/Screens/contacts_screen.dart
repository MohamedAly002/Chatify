import 'dart:developer';
import 'package:chatify/Screens/chat_screen.dart';
import 'package:chatify/Screens/home_screen.dart';
import 'package:chatify/cubit/users_list_cubit/users_list_state.dart';
import 'package:chatify/cubit/users_list_cubit/users_list_cubit.dart';
import 'package:chatify/custom%20widgets/custom_loading_indicator.dart';
import 'package:chatify/custom%20widgets/user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsScreen extends StatefulWidget {
  static const String routeName = 'contacts';
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UsersListCubit>(context).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: const Text(
          'Select contact',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        leading: BackButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false),
          color: const Color(0xFF31C48D),
        ),
      ),
      body: BlocConsumer<UsersListCubit, UsersListState>(
        listener: (context, state) {
          if (state is UsersListError) {
            log(state.error);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          if (state is UsersListLoading) {
            return const CustomLoadingIndicator();
          }

          if (state is UsersListError) {
            return Center(child: Text('Error: ${state.error}'));
          }

          if (state is UsersListLoaded) {
            final users = state.users; // Pass users from state
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contacts on Chatify',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (_, index) {
                        final user = users[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                          user: user,
                                          currentUserId: FirebaseAuth
                                              .instance.currentUser!.uid,
                                        )));
                          },
                          child: UserCard(
                            username: user['username'] ?? 'Unknown',
                            status: user['about'] ?? 'available',
                            profilePhotoUrl: user['profile_photo_url'],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('No contacts available.'));
        },
      ),
    );
  }
}
