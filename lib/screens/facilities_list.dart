import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhrs_app/providers/facilities.dart';
import '../constants.dart';
import '../widgets/facility_item2.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rhrs_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class FacilitiesList extends StatefulWidget {
  static const routeName = '/FacilitiesList';
  final int rate;
  final String facilityType;
  final int minCost, maxCost;
  final String start, end;
  final String location;

  FacilitiesList(
      {this.start,
      this.end,
      this.rate,
      this.facilityType,
      this.maxCost,
      this.minCost,
      this.location});

  @override
  _FacilitiesListState createState() => _FacilitiesListState();
}

class _FacilitiesListState extends State<FacilitiesList> {
  final controller = ScrollController();
  final spinKit = SpinKitFadingCircle(
    color: kPrimaryColor,
    size: 50.0,
  );

  @override
  void initState() {
    final facilitiesData = Provider.of<Facilities>(context, listen: false);
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        if (facilitiesData.nextUrl != null)
          facilitiesData.fetchNextMatched(
              startDate: widget.start,
              endDate: widget.end,
              rate: widget.rate,
              minCost: widget.minCost,
              maxCost: widget.maxCost,
              propertyType: widget.facilityType,
              location: widget.location);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesData = Provider.of<Facilities>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.facilitiesList.tr()),
      ),
      body: FutureBuilder(
        future: Provider.of<Facilities>(context, listen: false)
            .fetchMatchedFacilities(
                startDate: widget.start,
                endDate: widget.end,
                rate: widget.rate,
                minCost: widget.minCost,
                maxCost: widget.maxCost,
                propertyType: widget.facilityType,
                location: widget.location),
        builder: ((ctx, resultSnapShot) => resultSnapShot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator() /*spinKit*/)
            : Consumer<Facilities>(
                builder: (ctx, fetchedFacilities, child) => ListView.builder(
                  controller: controller,
                  itemBuilder: (context, index) {
                    if (index < fetchedFacilities.facilities.length)
                      return FacilityItem2(fetchedFacilities.facilities[index]);
                    else {
                      if (fetchedFacilities.nextUrl != null)
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      return SizedBox(
                        height: 0,
                      );
                    }
                  },
                  itemCount: fetchedFacilities.facilities.length + 1,
                ),
              )),
      ),
    );
  }
}
