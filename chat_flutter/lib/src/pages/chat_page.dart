import 'package:chat_flutter/src/services/database.dart';
import 'package:chat_flutter/src/widgets/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  final String chatRoomId;
  ConversationPage(this.chatRoomId);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  TextEditingController messageController = new TextEditingController();
  ScrollController controller = new ScrollController();

  Stream chatMessageStream;

  Widget ChatMessageList() {
    return Container(
      margin: EdgeInsets.only(bottom: 80),
      child: StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        snapshot.data.documents[index].data['message'],
                        snapshot.data.documents[index].data['sendBy'] ==
                            Constants.MyName);
                  },
                )
              : Container();
        },
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': messageController.text,
        'sendBy': Constants.MyName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      dataBaseMethods.addConvesationMessages(widget.chatRoomId, messageMap);
      messageController.text = '';
    }
  }

  @override
  void initState() {
    dataBaseMethods.getConvesationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('${widget.chatRoomId}',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              ChatMessageList(),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Theme.of(context).accentColor,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        controller: messageController,
                        decoration:
                            InputDecoration(hintText: 'Enviar mensaje...'),
                      )),
                      GestureDetector(
                          onTap: () {
                            sendMessage();
                          },
                          child: Container(child: Icon(Icons.send)))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSendByMe
              ? Theme.of(context).primaryColor
              : Theme.of(context).accentColor,
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isSendByMe ? Colors.white : Colors.black,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
