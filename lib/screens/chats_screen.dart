/*import 'package:flutter/material.dart';
import '../widgets/chat_list_tile.dart';
class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
    children: [
      ChatListTile(),
      Divider(),
      ChatListTile(),
      Divider(),
      ChatListTile(),
      Divider(),
      ChatListTile(),
      Divider(),
      ChatListTile(),
      Divider(),
      ChatListTile(),
    ],
    );
  }
}*/
import 'package:flutter/material.dart';
import 'all_chat.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: AllChats(),
            ),
          )
        ],
      );
  }
}
