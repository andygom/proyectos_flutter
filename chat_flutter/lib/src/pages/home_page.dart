import 'dart:collection';

import 'package:chat_flutter/models/user_model.dart';
import 'package:chat_flutter/src/pages/chat_page.dart';
import 'package:chat_flutter/src/pages/search_page.dart';
import 'package:chat_flutter/src/pages/signin_page.dart';
import 'package:chat_flutter/src/services/auth.dart';
import 'package:chat_flutter/src/services/database.dart';
import 'package:chat_flutter/src/widgets/authenticate.dart';
import 'package:chat_flutter/src/widgets/category_widget.dart';
import 'package:chat_flutter/src/widgets/constants.dart';
import 'package:chat_flutter/src/widgets/contacts_widget.dart';
import 'package:chat_flutter/src/widgets/helperfunctions.dart';
import 'package:chat_flutter/src/widgets/recentchats_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream chatRooms;
  Stream usuarios;

  Widget chatRoomsList() {
    ScrollController controller = new ScrollController();
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  print('o2k');
                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index].data['chatroomid']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.MyName, ""),
                    chatRoomId:
                        snapshot.data.documents[index].data["chatroomid"],
                  );
                  
                },
              )
            : Container(child: Text('NO'));
      },
    );
  }

  Widget UsersList() {
    return StreamBuilder(
      stream: usuarios,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return UsersTile(
                    userName: snapshot.data.documents[index].data['name'],
                    index: index,
                  );
                })
            : Container(child: Text('NO'));
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    getUserName();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.MyName = await HelperFunctions.getUserNameSharedPreference();
    DataBaseMethods().getChatRooms(Constants.MyName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.MyName}");
      });
    });
  }

  Future getUserName() async {
    DataBaseMethods().getAllUsers().then((snapshots) {
      setState(() {
        usuarios = snapshots;
        print(
            "we got the data + ${usuarios.toString()} this is name  ${Constants.MyName}");
      });
    });
/*     for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      usuarios = a.data['name'];
      print(usuarios);
    } */
  }

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      chatRoomsList(),
      UsersList(),
    ];
    final _kTabs = <Tab>[
      Tab(icon: Icon(Icons.forum), text: 'Mensajes'),
      Tab(icon: Icon(Icons.person), text: 'Contactos'),
    ];

    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Constants.MyName),
          elevation: 0.0,
          centerTitle: false,
          actions: [
            GestureDetector(
              onTap: () {
                AuthMethods().signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.exit_to_app)),
            )
          ],
          bottom: TabBar(
            tabs: _kTabs,
          ),
        ),
        body: TabBarView(
          children: _kTabPages,
        ),
      ),
    );
  }
}
/* return Scaffold(
      appBar: AppBar(
        title: Text(Constants.MyName),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              AuthMethods().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          UsersList(),
          chatRoomsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchPage()));
        },
      ),
    ); */

class UsersTile extends StatelessWidget {
  final String userName;
  final int index;

  UsersTile({this.userName, this.index});

  @override
  Widget build(BuildContext context) {
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
            context,
            MaterialPageRoute(
                builder: (context) => ConversationPage(chatRoomId)));
      } else {
        print('you cannot send message to yourself');
      }
    }

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(userName),
                // Text(userEmail, style: TextStyle(fontSize: 10)),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                createChatRoom(userName: userName);
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
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationPage(chatRoomId)));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
