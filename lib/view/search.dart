import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper/constant.dart';
import '../services/database.dart';
import '../view/conversation_screen.dart';
import '../widget/my_app_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DataBaseMethods _databaseMethods = DataBaseMethods();
  final _searchEditingController = TextEditingController();
  QuerySnapshot _searchResultSnapshot;

  bool _isLoading = false;
  bool _haveUserSearched = false;

  initiateSearch() async {
    if (_searchEditingController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await _databaseMethods
          .searchByName(_searchEditingController.text)
          .then((snapshot) {
        _searchResultSnapshot = snapshot;
        print("$_searchResultSnapshot");
        setState(() {
          _isLoading = false;
          _haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return _haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _searchResultSnapshot.docs.length,
            itemBuilder: (context, index) {
              return userTile(
                _searchResultSnapshot.docs[index].data()["userName"],
                _searchResultSnapshot.docs[index].data()["userEmail"],
              );
            })
        : Container();
  }

  /// 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage(String userName) async {
    List<String> users = [Constants.myName, userName];

    String chatRoomId = getChatRoomId(Constants.myName, userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    await _databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationScreen(chatRoomId: chatRoomId),
      ),
    );
  }

  Widget userTile(String userName, String userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                userEmail,
                style: TextStyle(color: Colors.black45, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MyAppBar('Single Chat'),
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    color: Theme.of(context).primaryColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchEditingController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: "search username ...",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            initiateSearch();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      const Color(0x36FFFFFF),
                                      const Color(0x0FFFFFFF)
                                    ],
                                    begin: FractionalOffset.topLeft,
                                    end: FractionalOffset.bottomRight),
                                borderRadius: BorderRadius.circular(40)),
                            padding: EdgeInsets.all(12),
                            child: Image.asset(
                              "assets/images/search_white.png",
                              height: 25,
                              width: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  userList()
                ],
              ),
            ),
    );
  }
}
