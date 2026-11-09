import 'package:chatify/features/contacts/presentation/screens/contacts_screen.dart';
import 'package:chatify/features/groups/presentation/screens/create_group_screen.dart';
import 'package:chatify/features/settings/presentation/screens/settings_screen.dart';
import 'package:chatify/features/home/presentation/widgets/chats_tab.dart';
import 'package:chatify/features/home/presentation/widgets/groups_tab.dart';
import 'package:flutter/material.dart';
import 'package:chatify/core/theme/app_colors.dart';
import 'package:chatify/core/constants/app_strings.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:const Padding(
            padding:  EdgeInsets.only(top: 15),
            child:  Text(
              AppStrings.appName,
              style: TextStyle(
                  color: AppColors.textPrimary, fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            tabs: [
              Tab(
                child: Text(
                  AppStrings.chats,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  AppStrings.groups,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              position: PopupMenuPosition.under,
              color: AppColors.primary,
              onSelected: (value) {
                if (value == 'settings') {
                  // Navigate to Settings screen (to be implemented)
                  Navigator.pushNamed(context, SettingsScreen.routeName);
                } else if (value == 'new_group') {
                  Navigator.pushNamed(context, CreateGroupScreen.routeName);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'new_group',
                    child: Text(
                      AppStrings.newGroup,
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'settings',
                    child: Text(
                      AppStrings.settings,
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ];
              },
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.textPrimary,
                size: 26,
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            ChatsTab(),
            GroupsTab(),
          ],
        ),
        floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, ContactsScreen.routeName);
            },
            shape: const CircleBorder(),
            backgroundColor: AppColors.primary,
            elevation: 6.0,
            child: Center(
                child: Image.asset(
              'assets/message_icon.png',
              fit: BoxFit.fill,
            )),
          ),
        ),
      ),
    );
  }
}
