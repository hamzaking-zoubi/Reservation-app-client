import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rhrs_app/providers/bookings.dart';
import 'package:rhrs_app/widgets/booking_item.dart';
import '../constants.dart';
import 'package:rhrs_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class BookingsScreen extends StatelessWidget {
  final spinKit = SpinKitFadingCircle(
    color: kPrimaryColor,
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Bookings>(context, listen: false).fetchMyBookings(),
      builder: ((ctx, resultSnapShot) => resultSnapShot.connectionState ==
              ConnectionState.waiting
          ? Center(child: CircularProgressIndicator() /*spinKit*/)
          : Consumer<Bookings>(
              builder: (ctx, fetchedBookings, child) =>
                  fetchedBookings.bookings.length != 0
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            return BookingCard(fetchedBookings.bookings[index]);
                          },
                          itemCount: fetchedBookings.bookings.length,
                        )
                      : Center(
                          child: Text(
                            LocaleKeys.noBookedFacilities.tr(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
            )),
    );
  }
}
