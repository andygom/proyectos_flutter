import 'package:flutter/material.dart';

class Contacts extends StatelessWidget {
  const Contacts({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List contacts = ['Andy', 'Juan', 'Sofia'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Contactos',
                  style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {},
                  iconSize: 30,
                  color: Colors.orangeAccent,
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            child: ListView.builder(
                padding: EdgeInsets.only(left: 10),
                scrollDirection: Axis.horizontal,
                itemCount: contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black,
                        ),
                        SizedBox(height: 6),
                        Text(
                          contacts[index],
                          style: TextStyle(color: Colors.orangeAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
