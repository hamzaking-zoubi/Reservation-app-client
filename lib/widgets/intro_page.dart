import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  final String imageUrl;
  IntroPage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        imageUrl,
      ),
    );
  }
}
