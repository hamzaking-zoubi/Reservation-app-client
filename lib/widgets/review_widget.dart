import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:rhrs_app/constants.dart';

class Review extends StatelessWidget {
  static const _STAR_ICON = 'assets/icons/home_screen/bp_star_icon.svg';
  //final DateTime time = DateTime.now();

  final id;
  final id_facility;
  final id_user;
  final comment;
  final rate;
  final String time;
  final name;
  final path_photo;

  Review(
      {@required this.id,
        @required this.id_facility,
        @required this.id_user,
        @required this.comment,
        @required this.rate,
        @required this.time,
        @required this.name,
        @required this.path_photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(localApi + path_photo),
                radius: 20,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(children: [
            for (int i = 0; i < rate; i++) SvgPicture.asset(_STAR_ICON, height: 20),
            SizedBox(
              width: 12,
            ),
            Text(
              '${DateFormat.yMMMd().format(DateTime.parse(time))}',
              style: TextStyle(fontSize: 14),
            )
          ]),
          SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
                /*'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exertion ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voltate velit esse cillum dolore eu fugiat nulla pariatur anim id est laborum.',
            */comment,style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
