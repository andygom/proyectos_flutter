import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .getDocuments();
  }

  getUserByEmail(String userEmail) async {
    return await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection('users').add(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection('ChatRoom')
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConvesationMessages(String chatRoomId) async {
    return await Firestore.instance
        .collection('ChatRoom')
        .document(chatRoomId)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  addConvesationMessages(String chatRoomId, messageMap) {
    Firestore.instance
        .collection('ChatRoom')
        .document(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getChatRooms(String userName) async {
    return await Firestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: userName)
        .snapshots();
  }

  getAllUsers() async {
    return await Firestore.instance.collection("users").snapshots();
  }
}
