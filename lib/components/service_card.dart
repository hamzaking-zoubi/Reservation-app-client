import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants.dart';

class ServiceCard extends StatelessWidget {
  final double size;
  final String iconUrl;
  final double fontSize;
  final String name;
  final bool disabled;
  final Function onPressed;
  final Color color;
  final double radius;

  const ServiceCard(
      {this.size,
      this.iconUrl,
      this.fontSize,
      this.name,
      this.disabled = false,
      this.onPressed,
      this.color,
      this.radius});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(radius)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              iconUrl,
              width: size,
              height: size,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        SIZED_BOX_H06,
        Text(name,
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: kPrimaryColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold))
      ],
    );
  }
}
