import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  getUserByUserName(String userName) async{
    return await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: userName)
        .get();
  }

  getUserByUserEmail(String userEmail) async{
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection('users').add(userMap);
  }
  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance.collection('chatRoom').doc(chatRoomId).set(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }
}
