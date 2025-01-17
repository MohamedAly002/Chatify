import 'package:chatify/Screens/contacts_screen.dart';
import 'package:chatify/Screens/create_group_screen.dart';
import 'package:chatify/Screens/settings_screen.dart';
import 'package:chatify/Tabs/chats_tab.dart';
import 'package:chatify/Tabs/groups_tab.dart';
import 'package:flutter/material.dart';

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
              'Chatify',
              style: TextStyle(
                  color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Color(0xFF31C48D),
            labelColor: Color(0xFF31C48D),
            tabs: [
              Tab(
                child: Text(
                  'Chats',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  'Groups',
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
              color: const Color(0xFF31C48D),
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
                      'New group',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'settings',
                    child: Text(
                      'Settings',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ];
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
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
            backgroundColor: const Color(0xFF31C48D),
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
