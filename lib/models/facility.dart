import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rhrs_app/constants.dart';
import 'dart:convert';
import 'facility_photo.dart';
import 'review.dart';

enum FacilityType { HOSTEL, RESORT, CHALET }

class Facility extends ChangeNotifier {
  final String id;
  final String ownerId;
  final String name;
  final String location; //
  final String description;
  final int cost; //
  final List<FacilityPhoto> facilityImages;
  final int numberOfGuets; //
  final int numberOfRooms; //
  final FacilityType facilityType; //
  final int rate; //
  final bool hasWifi;
  final bool hasCoffee;
  final bool hasCondition;
  final bool hasFridge;
  final bool hasTv;
  final type; //temp
  bool isFavorite = false;
  final List<ReviewModel> reviews;

  Facility({
    @required this.id,
    @required this.name,
    @required this.location,
    @required this.description,
    @required this.cost,
    @required this.facilityImages,
    @required this.numberOfGuets,
    @required this.numberOfRooms,
    @required this.facilityType,
    @required this.rate,
    @required this.ownerId,
    this.isFavorite = false,
    this.type,
    this.hasWifi,
    this.hasFridge,
    this.hasTv,
    this.hasCondition,
    this.hasCoffee,
    this.reviews
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(var authToken,String facID) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    String token = "Bearer" + " " + authToken;
    notifyListeners();
    var url = Uri.parse(localApi + "api/favorite/toggle");
    //var url = Uri.parse("http://192.168.43.181:8000/api/favorite/toggle");

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': token
    };

    try {
      //print("gooooooooooooooooooooooooooooooot");
      final response = await http.post(
        url,
        headers : headers,
        body: json.encode({
          "id_facility": facID,
        }),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
      print(response.body);
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }

  factory Facility.fromJson(Map<String, dynamic> json) => Facility(
        type: json['type'].toString(),
        cost: json['cost'] == null ? 0.0 : json['cost'].toDouble(),
        name: json["name"].toString(),
        description: json["description"].toString(),
        id: json["id"].toString(),
        numberOfGuets: json["num_guest"],
        numberOfRooms: json["num_room"],
        /*listImage: (json['photos'] as List)
        .map((data) => Photo.fromJson(data))
        .toList(),*/
        location: json["location"].toString(),
        //hasAirConditioning: json["air_condition"] == 0 ? false : true,
        //coffee_machine: json["coffee_machine"] == 0 ? false : true,
        //fridge: json["fridge"] == 0 ? false : true,
        //tv: json["tv"] == 0 ? false : true,
        //id_user: json["id_user"].toString(),
        rate: json["rate"] == null ? 0 : json["rate"].toDouble(),
        //wifi: json["wifi"] == 0 ? false : true,
      );
}
