import 'package:chat_flutter/src/pages/home_page.dart';
import 'package:chat_flutter/src/widgets/authenticate.dart';
import 'package:chat_flutter/src/widgets/helperfunctions.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userisLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userisLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.grey[200],
      ),
      home: userisLoggedIn != null ? userisLoggedIn ? ChatPage() : 
      Authenticate() : Container( child: Center (child: Authenticate())),
    );
  }
}

