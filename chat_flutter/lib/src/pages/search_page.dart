import 'package:chat_flutter/src/pages/chat_page.dart';
import 'package:chat_flutter/src/services/database.dart';
import 'package:chat_flutter/src/widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.documents.length,
            itemBuilder: (context, index) {
              return SearchTile(
                username: searchSnapshot.documents[index].data['name'],
                userEmail: searchSnapshot.documents[index].data['email'],
              );
            },
          )
        : Container();
  }

  initSearch() {
    dataBaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  //create chatroom
  createChatRoom({String userName}) {
    if (userName != Constants.MyName) {
      String chatRoomId = getChatRoomId(userName, Constants.MyName);
      List<String> users = [userName, Constants.MyName];
      Map<String, dynamic> chatRoomMap = {
        'users': users,
        'chatroomid': chatRoomId,
      };
      DataBaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ConversationPage(chatRoomId)));
    } else {
      print('you cannot send message to yourself');
    }
  }

  Widget SearchTile({String username, String userEmail}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(username),
                Text(userEmail, style: TextStyle(fontSize: 10)),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                createChatRoom(userName: username);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Text('Chat', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Buscar Contactos',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 28)),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: searchTextEditingController,
                  decoration: InputDecoration(hintText: 'Buscar usuario'),
                )),
                GestureDetector(
                    onTap: () {
                      initSearch();
                    },
                    child: Container(child: Icon(Icons.search)))
              ],
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
