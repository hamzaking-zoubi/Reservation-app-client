import 'package:flutter/material.dart';
import 'package:rhrs_app/models/facility.dart';
import '../constants.dart';
import '../components/details extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rhrs_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class DetailScreen extends StatelessWidget {
  final List<ImageProvider> facilityImages;
  final String facilityType;
  final String facilityName;
  final int rate;
  final String description;
  final int cost;

  static const routeName = '/details_screen';

  DetailScreen(
      {this.facilityImages,
      this.facilityType,
      this.facilityName,
      this.rate,
      this.description,
      this.cost});

  static const _LOADING_IMAGE = 'assets/images/bp_loading.gif';
  static const _BACKWARD_ICON =
      'assets/icons/signin_screen/bp_backward_icon.svg';

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    final _dtlPriceTextStyle = Theme.of(context)
        .textTheme
        .headline3
        .copyWith(color: kBackgroundLightColor, fontWeight: FontWeight.w500);
    final _dtlSubTextStyle = Theme.of(context)
        .textTheme
        .headline5
        .copyWith(color: kBackgroundLightColor, fontWeight: FontWeight.normal);
    final _dtlButtonTextStyle = Theme.of(context).textTheme.headline6.copyWith(
        color: kPrimaryColor, fontWeight: FontWeight.w600, fontSize: 14);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SizedBox.expand(
                child: FadeInImage(
                  image: ResizeImage(
                      AssetImage(
                          'assets/images/facility.jpg') /*facilityImages[0]*/,
                      width: _screenWidth.round(),
                      height: _screenHeight.round()),
                  placeholder: AssetImage(_LOADING_IMAGE),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, left: 20),
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 24,
                  width: 24,
                  child: SvgPicture.asset(_BACKWARD_ICON,
                      color: kBackgroundLightColor),
                ),
              ),
            ),

            // Draggable for extended the info
            DraggableScrollableSheet(
              initialChildSize: .2,
              maxChildSize: .5,
              minChildSize: .2,
              builder: (context, scrollController) => SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  height: _screenHeight * 0.45,
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Stack(
                    children: [
                      DetailExtension(
                        facilityType: facilityType,
                        description: description,
                        name: facilityName,
                        rate: rate,
                      ),
                      Positioned(
                        top: 12,
                        left: _screenWidth / 2 - 12,
                        child: Container(
                          width: 24,
                          height: 4,
                          decoration: BoxDecoration(
                              color: kSubTextColor.withOpacity(.3),
                              borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom contain price and booking button
      bottomNavigationBar: SizedBox(
          height: 72,
          child: Container(
            padding: PAD_SYM_H20,
            color: kPrimaryColor,
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('\$$cost', style: _dtlPriceTextStyle),
                  Text(LocaleKeys.night.tr(), style: _dtlSubTextStyle),
                  Spacer(),
                  RawMaterialButton(
                      elevation: 0,
                      fillColor: kBackgroundLightColor,
                      constraints: BoxConstraints(minHeight: 42, minWidth: 100),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/calendar'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(LocaleKeys.bookNow.tr(), style: _dtlButtonTextStyle))
                ],
              ),
            ),
          )),
    );
  }
}