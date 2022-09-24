import 'package:flutter/material.dart';
import 'constants.dart';


final TextStyle bodyTextMessage =
TextStyle(fontSize: 13, letterSpacing: 1.5, fontWeight: FontWeight.w600);

final TextStyle bodyTextTime = TextStyle(
    fontStyle: FontStyle.italic,
    color: Color(0xffAEABC9),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
);

final TextStyle chatSenderName = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
);


final themeCustomed = ThemeData(
    //accentColor: Colors.blueAccent,
    fontFamily: 'Raleway',
    primaryColor: kPrimaryColor,
    backgroundColor: kBackgroundLightColor,
    scaffoldBackgroundColor: kBackgroundColor,
    textTheme: TextTheme(
        headline1: TextStyle(
            color: kPrimaryDarkenColor,
            fontSize: 40,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w500),
        headline2: TextStyle(
            color: kPrimaryDarkenColor,
            fontSize: 32,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w500),
        headline3: TextStyle(
            color: kPrimaryDarkenColor,
            fontSize: 28,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w500),
        headline4: TextStyle(
            color: kPrimaryColor,
            fontSize: 24,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.bold),
        headline5: TextStyle(
            color: kPrimaryColor,
            fontSize: 20,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.bold),
        headline6: TextStyle(
            color: kPrimaryColor,
            fontSize: 18,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.bold),
        subtitle1:
        TextStyle(color: kPrimaryColor, fontSize: 16, fontFamily: 'Rubik'),
        subtitle2: TextStyle(
            color: kPrimaryDarkenColor, fontSize: 14, fontFamily: 'Rubik'),
        bodyText2: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 10,
            fontFamily: 'Rubik'),
        bodyText1: TextStyle(
            color: kTagRentColor,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            fontFamily: 'Rubik')),);
    /*inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
            color: kDisabledButtonColor, fontSize: 14, fontFamily: 'Rubik'),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none)));*/
