import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Single Chat',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: Center(
        child: Text('Chat'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx)=> SearchScreen(),),);
        },
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
