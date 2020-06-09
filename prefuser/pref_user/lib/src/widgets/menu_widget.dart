import 'package:flutter/material.dart';

import 'package:pref_user/src/pages/home_page.dart';
import 'package:pref_user/src/pages/settings_page.dart';

class MenuWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Container(),
          /* decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(assetName),
              fit: BoxFit.cover,
            )), */
        ),
        ListTile(
          leading: Icon(Icons.pages, color: Colors.blue),
          title: Text('Home'),
          onTap: () => Navigator.pushReplacementNamed(context, HomePage.routeName ),
        ),
        ListTile(
          leading: Icon(Icons.person, color: Colors.blue),
          title: Text('People'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.settings, color: Colors.blue),
          title: Text('Settings'),
         // onTap: () => Navigator.pushNamed(context, SettingsPage.routeName),
         onTap: (){
           //Navigator.pop(context);
           Navigator.pushReplacementNamed(context, SettingsPage.routeName);
         },
        ),
      ],
    ),
  );
  }
}