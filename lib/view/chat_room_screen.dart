import 'package:flutter/material.dart';
import 'package:single_chat/services/database.dart';

import '../helper/constant.dart';
import '../helper/helper_function.dart';
import '../services/auth_methods.dart';
import '../view/auth_screen.dart';
import '../view/search.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;
  AuthMethods _authMethods = AuthMethods();

  @override
  void initState() {
    getUserInfoChat();
    super.initState();
  }

  getUserInfoChat() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DataBaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
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

// class ChatRoomsTile extends StatelessWidget {
//   final String userName;
//   final String chatRoomId;
//
//   ChatRoomsTile({this.userName,@required this.chatRoomId});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){
//         Navigator.push(context, MaterialPageRoute(
//             builder: (context) => Chat(
//               chatRoomId: chatRoomId,
//             )
//         ));
//       },
//       child: Container(
//         color: Colors.black26,
//         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//         child: Row(
//           children: [
//             Container(
//               height: 30,
//               width: 30,
//               decoration: BoxDecoration(
//                   color: CustomTheme.colorAccent,
//                   borderRadius: BorderRadius.circular(30)),
//               child: Text(userName.substring(0, 1),
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontFamily: 'OverpassRegular',
//                       fontWeight: FontWeight.w300)),
//             ),
//             SizedBox(
//               width: 12,
//             ),
//             Text(userName,
//                 textAlign: TextAlign.start,
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontFamily: 'OverpassRegular',
//                     fontWeight: FontWeight.w300))
//           ],
//         ),
//       ),
//     );
//   }
// }