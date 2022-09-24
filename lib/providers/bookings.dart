import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rhrs_app/constants.dart';
import 'package:rhrs_app/models/booking.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Bookings extends ChangeNotifier {
  List<Booking> bookings = [];

  Future<void> fetchMyBookings() async {
    bookings = [];
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
    final List<Booking> _loadedBookings = [];
    const API = localApi + "api/bookings/show";
    try {
      final response = await http.get(Uri.parse(API), headers: headers);
      final extractedData = json.decode(response.body);
      final data = (extractedData['infoBookings'] as List)
          .map((data) => Booking(
                id: data['id'].toString(),
                facilityId: data['id_facility'],
                startDate: data['start_date'],
                endDate: data['end_date'],
                bookingCost: data['cost'],
                facilityName: data['name'],
                facilityPhotoPath: data['path_photo'],
                creationDate: data['created_at'],
                userId: data['id_user'],
              ))
          .toList();
      bookings.addAll(data);

//      PusherOptions options = PusherOptions(
//        wsPort: 6001,
//        encrypted: false,
//        auth: PusherAuth(
//          localApi+'api/broadcasting/auth',
//          headers: {
//            'Authorization': token,
//          },
//        ),
//      );
//      PusherClient pusher = PusherClient(
//          '98034be202413ea485fc',
//          options,
//          autoConnect: false
//      );
//// connect at a later time than at instantiation.
//      pusher.connect();
//

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
