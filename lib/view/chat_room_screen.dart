import 'package:flutter/material.dart';
import 'package:single_chat/helper/constant.dart';
import 'package:single_chat/helper/helper_function.dart';

import '../view/auth_screen.dart';
import '../services/auth_methods.dart';
import '../view/search.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods _authMethods = AuthMethods();

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Single Chat',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _authMethods.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                );
              })
        ],
      ),
      body: Center(
        child: Text('Chat'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => SearchScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
