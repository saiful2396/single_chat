import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper/constant.dart';
import '../services/database.dart';
import '../view/conversation_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  QuerySnapshot searchSnapshots;

  initiateSearch() async {
    QuerySnapshot results =
        await _dataBaseMethods.getUserByUserName(_searchController.text);
    setState(() {
      searchSnapshots = results;
    });
  }

  createChatRoomAndConversation(String userName) {
    if(userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        'users': users,
        'chatRoom': chatRoomId,
      };
      _dataBaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConversationScreen(),
        ),
      );
    }
  }

  Widget searchList() {
    return searchSnapshots != null
        ? ListView.builder(
            itemCount: searchSnapshots.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return SearchTile(
                email: searchSnapshots.docs[i].data()['email'],
                userName: searchSnapshots.docs[i].data()['userName'],
                conversation: createChatRoomAndConversation(searchSnapshots.docs[i].data()['userName'],),
              );
            })
        : Container();
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Single Chat',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.black54),
                      decoration: InputDecoration(
                          hintText: 'Search userName...',
                          border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        initiateSearch();
                      })
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String userName;
  final String email;
  final Function conversation;

  SearchTile({this.email, this.userName, this.conversation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                email,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Spacer(),
          InkWell(
            onTap: conversation,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).primaryColor),
              child: Text(
                'Message',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
