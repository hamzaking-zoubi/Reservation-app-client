import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhrs_app/models/booking.dart';
import 'package:rhrs_app/models/facility.dart';
import 'package:rhrs_app/providers/bookings.dart';
import 'package:rhrs_app/providers/facilities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../screens/test_details_screen.dart';
import 'package:rhrs_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class BookingCard extends StatefulWidget {
  final Booking booking;

  BookingCard(this.booking);

  static const _LOADING_IMAGE = 'assets/images/bp_loading.gif';

  @override
  _BookingCardState createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  bool _expanded = false;

  //!!!TO BE MOVED!!!
  Future<bool> cancelReservation(String bookingId, String facilityId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    String authToken = extractedData['token'];

    String token = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      'Authorization': token,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    const API = localApi + "api/bookings/unbooking";
    try {
      final response = await http.delete(
        Uri.parse(API),
        headers: headers,
        body: json.encode({"id_booking": bookingId, "id_facility": facilityId}),
      );
      var responseData = await json.decode(response.body);
      print(responseData);
      if (responseData['Error'] != null) {
        return false;
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _bodTitleTextStyle = Theme.of(context)
        .textTheme
        .headline5
        .copyWith(color: kPrimaryDarkenColor, fontWeight: FontWeight.w500);
    final _bodBody2TextStyle = Theme.of(context).textTheme.bodyText2;
    final _bodBody1TextStyle = Theme.of(context).textTheme.bodyText1;

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      child: Container(
        width: 248,
        height: _expanded ? 370 : 240,
        decoration: BoxDecoration(
            color: kBackgroundLightColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 10), blurRadius: 30, color: kShadowColor)
            ]),
        child: Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: Container(
                  width: double.infinity,
                  height: 154,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FadeInImage(
                          placeholder: AssetImage(BookingCard._LOADING_IMAGE),
                          image: widget.booking.facilityPhotoPath != null
                              ? NetworkImage(
                                  localApi + widget.booking.facilityPhotoPath)
                              : AssetImage('assets/images/facility.jpg'),
                          //facility.facilityImages[0],
                          width: double.infinity,
                          fit: BoxFit.cover)),
                ),
              ),
              Padding(
                padding: PAD_SYM_H16,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${widget.booking.facilityName}',
                            style: TextStyle(
                              fontSize: 16,
                              color: kTagRentColor,
                            )),
                        IconButton(
                            icon: _expanded
                                ? Icon(Icons.expand_less)
                                : Icon(Icons.expand_more),
                            onPressed: () {
                              setState(() {
                                _expanded = !_expanded;
                              });
                            }),
                      ]),
                  if (_expanded)
                    Flexible(
                      child: Container(
                        height: 135,
                        child: ListView(children: [
                          Row(
                            children: [
                              Text(
                                LocaleKeys.from.tr(),
                                style: TextStyle(
                                    fontSize: 14, color: Colors.green),
                              ),
                              Text(
                                ' ${widget.booking.startDate.toString().substring(0, 10)} ',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Text(
                                LocaleKeys.to.tr(),
                                style:
                                    TextStyle(fontSize: 14, color: Colors.red),
                              ),
                              Text(
                                ' ${widget.booking.endDate.toString().substring(0, 10)}',
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),
                          Text(
                            LocaleKeys.costOfBooking.tr() +
                                ' ${widget.booking.bookingCost}\$',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            LocaleKeys.numberOfBookedDays.tr() + ' ${DateTime.parse(widget.booking.endDate).difference(DateTime.parse(widget.booking.startDate)).inDays}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  Facility fetched = await Provider.of<
                                          Facilities>(context, listen: false)
                                      .getFacilityDetails(
                                          widget.booking.facilityId.toString());
                                  if (fetched != null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => NewDetailsScreen(
                                                  id: fetched.id,
                                                  ownerId: fetched.ownerId,
                                                  facilityName: fetched.name,
                                                  cost: fetched.cost,
                                                  rate: fetched.rate,
                                                  description:
                                                      fetched.description,
                                                  facilityImages:
                                                      fetched.facilityImages,
                                                  facilityType: fetched.type,
                                                  //getFacilityType(facility.facilityType),
                                                  location: fetched.location,
                                                  hasCoffee: fetched.hasCoffee,
                                                  hasCondition:
                                                      fetched.hasCondition,
                                                  hasFridge: fetched.hasFridge,
                                                  hasTv: fetched.hasTv,
                                                  hasWifi: fetched.hasWifi,
                                                )));
                                  }
                                },
                                child: Text(LocaleKeys.details.tr()),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0)),
                                  primary: Theme.of(context).primaryColor,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final isCanceled = await cancelReservation(
                                      widget.booking.id.toString(),
                                      widget.booking.facilityId.toString());
                                  if (isCanceled) {
                                    print('done successfully');
                                  }
                                  await Provider.of<Bookings>(context,
                                          listen: false)
                                      .fetchMyBookings();
                                },
                                child: Text(LocaleKeys.cancelReservation.tr()),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  primary: Color(0xFFc82333),
                                ),
                              ),
                            ],
                          )
                        ]),
                      ),
                    ),
                ]),
              )
            ]),
      ),
    );
  }
}
