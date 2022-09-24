import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final String buttonLabel;
  Function onPress;
  CustomButton({@required this.buttonLabel,this.onPress});
  @override
  Widget build(BuildContext context) {

    return Container(
      width: 380,
      height: 50,
      child: ElevatedButton(
        onPressed: onPress,
        child: Text(
          buttonLabel,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          primary: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}