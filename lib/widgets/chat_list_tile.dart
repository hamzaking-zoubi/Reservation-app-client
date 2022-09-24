import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatListTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage("https://picsum.photos/200"),
            radius: 25.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Anas Bakkar',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            SizedBox(height: 7,),
            Text('Hi There ! I was waiting outside',style: TextStyle(fontSize: 14),),
          ],
        ),
        SizedBox(width: MediaQuery.of(context).size.width > 500 ? screenWidth/1.8 : screenWidth/4.5,),
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 2),
            child: Text('9',style: TextStyle(fontSize: 12,color: Colors.white),),
          ),
        )
      ],
    );
  }
}
