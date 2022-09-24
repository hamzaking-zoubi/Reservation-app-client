import 'package:flutter/material.dart';
import 'package:rhrs_app/models/facility.dart';
import 'package:rhrs_app/screens/facility_details_screen.dart';
import 'package:rhrs_app/screens/test_details_screen.dart';
import '../constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FacilityItem2 extends StatelessWidget {
  final Facility facility;

  FacilityItem2(this.facility);

  static const _LOADING_IMAGE = 'assets/images/bp_loading.gif';
  static const _BOOKMARK_ICON = 'assets/icons/home_screen/bp_bookmark_icon.svg';
  static const _LOCATION_ICON = 'assets/icons/home_screen/bp_location_icon.svg';
  static const _STAR_ICON = 'assets/icons/home_screen/bp_star_icon.svg';

  String getFacilityType(FacilityType facilityType) {
    if (facilityType == FacilityType.RESORT) {
      return 'Resort';
    } else if (facilityType == FacilityType.CHALET) {
      return 'Chalet';
    } else if (facilityType == FacilityType.HOSTEL) {
      return 'Hostel';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final _bodTitleTextStyle = Theme.of(context)
        .textTheme
        .headline5
        .copyWith(color: kPrimaryDarkenColor, fontWeight: FontWeight.w500);
    final _bodBody2TextStyle = Theme.of(context).textTheme.bodyText2;
    final _bodBody1TextStyle = Theme.of(context).textTheme.bodyText1;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                NewDetailsScreen(
              id: facility.id,
              ownerId: facility.ownerId,
              facilityName: facility.name,
              cost: facility.cost,
              rate: facility.rate,
              description: facility.description,
              facilityImages: facility.facilityImages,
              facilityType: facility.type,
              location: facility.location,
              hasCoffee: facility.hasCoffee,
              hasCondition: facility.hasCondition,
              hasFridge: facility.hasFridge,
              hasTv: facility.hasTv,
              hasWifi: facility.hasWifi,
            ),
          ),
        );
      },
      child: Card(
        elevation: 8.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        child: Container(
          width: 248,
          height: 268,
          decoration: BoxDecoration(
              color: kBackgroundLightColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 10), blurRadius: 30, color: kShadowColor)
              ]),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 154,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FadeInImage(
                              placeholder: AssetImage(_LOADING_IMAGE),
                              image: facility.facilityImages.length != 0
                                  ? NetworkImage(localApi +
                                      facility.facilityImages[0].photoPath)
                                  : AssetImage('assets/images/facility.jpg'),
                              //facility.facilityImages[0],
                              width: double.infinity,
                              fit: BoxFit.cover)),
                    ),
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: Container(
                        width: 108,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: kBackgroundColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Text('Start From: \$${facility.cost}',
                            style: _bodBody2TextStyle),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: PAD_SYM_H16,
                child: Row(
                  children: [
                    Text('${facility.type}', style: _bodBody1TextStyle),
                    Spacer(),
                    //SvgPicture.asset(_BOOKMARK_ICON)
                  ],
                ),
              ),
              SIZED_BOX_H06,
              Padding(
                padding: PAD_SYM_H16,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('${facility.name}', style: _bodTitleTextStyle),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    SvgPicture.asset(_LOCATION_ICON),
                    SIZED_BOX_W06,
                    Text(facility.location,
                        style: _bodBody1TextStyle.copyWith(
                            color: kPrimaryDarkenColor)),
                    SIZED_BOX_W20,
                    for (int i = 0; i < facility.rate; i++)
                      SvgPicture.asset(_STAR_ICON),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
