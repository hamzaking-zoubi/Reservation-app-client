//import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import '../components/custom_clipper.dart';
import '../constants.dart';
import 'top_bar.dart';

class StackContainer extends StatelessWidget {

  final userName;
  final userImage;

  const StackContainer({
    this.userName,
    this.userImage
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: Stack(
        children: <Widget>[
          Container(),
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              height: 300.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage : NetworkImage(localApi + userImage),//: NetworkImage('https://i.pravatar.cc/300'),//NetworkImage('https://i.pravatar.cc/300'),
                  radius: 60.0,
                ),
                SizedBox(height: 10.0),
                Text(
                  '$userName',
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          TopBar(),
        ],
      ),
    );
  }
}