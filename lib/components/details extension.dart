import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhrs_app/components/service_card.dart';
import 'package:rhrs_app/models/facility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class DetailExtension extends StatelessWidget {
  final String facilityType;
  final int rate;
  final String name;
  final String description;
  final String location;
  final List<String> amenities;
  final bool hasWifi;
  final bool hasCoffee;
  final bool hasCondition;
  final bool hasFridge;
  final bool hasTv;
  String id;

  DetailExtension(
      {this.id,
      this.name,
      this.facilityType,
      this.description,
      this.rate,
      this.location,
      this.amenities,
      this.hasWifi,
      this.hasCoffee,
      this.hasCondition,
      this.hasFridge,
      this.hasTv});

  static const _LOCATION_ICON = 'assets/icons/home_screen/bp_location_icon.svg';
  static const _STAR_ICON = 'assets/icons/home_screen/bp_star_icon.svg';

  @override
  Widget build(BuildContext context) {
    final _dtlTypeTextStyle =
        Theme.of(context).textTheme.subtitle2.copyWith(color: kTagHotelColor);

    final _dtlTitleTextStyle = Theme.of(context).textTheme.headline2;
    final _dtlSubTitleTextStyle = Theme.of(context)
        .textTheme
        .headline5
        .copyWith(color: kPrimaryDarkenColor, fontWeight: FontWeight.w500);
    final _dtlSub1TextStyle = Theme.of(context)
        .textTheme
        .subtitle1
        .copyWith(color: kPrimaryDarkenColor, fontWeight: FontWeight.w600);
    final _dtlBody1TextStyle = Theme.of(context)
        .textTheme
        .bodyText1
        .copyWith(color: kPrimaryDarkenColor, fontWeight: FontWeight.normal);

    return Padding(
      padding: PAD_SYM_H20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Text(facilityType, style: _dtlTypeTextStyle),
                Spacer(),
                Consumer<Facility>(
                  builder: (ctx, fac, _) => IconButton(
                      icon: Icon(
                          fac.isFavorite
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: Theme.of(context).primaryColor),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        final extractedData =
                            json.decode(prefs.getString('userData'))
                                as Map<String, dynamic>;
                        String token = extractedData['token'];
                        await fac.toggleFavoriteStatus(token, id);
                      }),
                ),
              ],
            ),
          ),
          //SIZED_BOX_H06,
          Text(name, style: _dtlTitleTextStyle),
          SIZED_BOX_H12,
          Row(
            children: [
              SvgPicture.asset(_LOCATION_ICON, height: 20),
              SIZED_BOX_W06,
              Text(
                '$location',
                style: _dtlSub1TextStyle,
              ),
              SIZED_BOX_W20,
              for (int i = 0; i < rate; i++)
                SvgPicture.asset(_STAR_ICON, height: 20),
              SIZED_BOX_W06,
            ],
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 12, 20, 12),
              child: Text(description,
                  style: _dtlSub1TextStyle.copyWith(
                      height: 1.5,
                      color: kSubTextColor,
                      fontWeight: FontWeight.normal)),
            ),
            Text(DTL_AMENITY_TEXT, style: _dtlSubTitleTextStyle),
            SIZED_BOX_H06,
            Row(children: [
              hasWifi
                  ? ServiceCard(
                      name: 'Wifi',
                      fontSize: 12,
                      size: 45,
                      iconUrl: 'assets/icons/detail_screen/wifi.svg',
                      radius: 12,
                      color: kBackgroundLightColor)
                  : SizedBox(
                      width: 1,
                    ),
              SizedBox(
                width: 10,
              ),
              hasCoffee
                  ? ServiceCard(
                      name: 'Coffee',
                      fontSize: 12,
                      size: 45,
                      iconUrl: 'assets/icons/detail_screen/coffe_machine.svg',
                      radius: 12,
                      color: kBackgroundLightColor)
                  : SizedBox(
                      width: 1,
                    ),
              SizedBox(
                width: 10,
              ),
              hasCondition
                  ? ServiceCard(
                      name: 'Conditioner',
                      fontSize: 12,
                      size: 45,
                      iconUrl: 'assets/icons/detail_screen/air-conditioner.svg',
                      radius: 12,
                      color: kBackgroundLightColor)
                  : SizedBox(
                      width: 1,
                    ),
              SizedBox(
                width: 10,
              ),
              hasTv
                  ? ServiceCard(
                      name: 'TV',
                      fontSize: 12,
                      size: 45,
                      iconUrl: 'assets/icons/detail_screen/tv.svg',
                      radius: 12,
                      color: kBackgroundLightColor)
                  : SizedBox(
                      width: 1,
                    ),
              SizedBox(
                width: 10,
              ),
              hasFridge
                  ? ServiceCard(
                      name: 'Fridge',
                      fontSize: 12,
                      size: 45,
                      iconUrl: 'assets/icons/detail_screen/fridge1.svg',
                      radius: 12,
                      color: kBackgroundLightColor)
                  : SizedBox(
                      width: 1,
                    ),
            ]),
          ])
        ],
      ),
    );
  }
}
