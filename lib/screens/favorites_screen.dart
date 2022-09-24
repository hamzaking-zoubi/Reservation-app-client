import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rhrs_app/providers/facilities.dart';
import 'package:rhrs_app/widgets/facility_item2.dart';
import 'package:rhrs_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import '../constants.dart';

class FavoritesScreen extends StatelessWidget {
  final spinKit = SpinKitFadingCircle(
    color: kPrimaryColor,
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    final savedFacilities = Provider.of<Facilities>(context, listen: false);
    return FutureBuilder(
      future: Provider.of<Facilities>(context, listen: false)
          .fetchSavedFacilities(),
      builder: ((ctx, resultSnapShot) =>
          resultSnapShot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator()/*spinKit*/)
              : savedFacilities.savedFacilities.length != 0
                  ? ListView.builder(
                      itemBuilder: (context, index) =>
                          FacilityItem2(savedFacilities.savedFacilities[index]),
                      itemCount: savedFacilities.savedFacilities.length,
                    )
                  : Center(
                    child: Text(
                        LocaleKeys.noFavorites.tr(),
                        style: TextStyle(fontSize: 16),
                      ),
                  )),
    );
  }
}
