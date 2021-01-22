import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods{
  getUserByUserName(){

  }
  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection('users').add(userMap);
  }
}