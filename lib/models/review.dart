import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class ReviewModel extends ChangeNotifier {
  final rate;
  final comment;
  final id;
  final id_facility;
  final id_user;
  final name;
  final path_photo;
  final time;

  ReviewModel({this.rate, this.comment,this.id,this.name,this.id_facility,this.id_user,this.path_photo,this.time});

  Future<String> addRate(String facilityId, int userRate) async {
    final API = localApi + 'api/user/rate';
    var url = Uri.parse(API);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('token${prefs.get('token')}');
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    String token = extractedData['token'];

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer" + " " + token
    };
    try {
      final response = await http.post(url,
          headers: headers,
          body: json.encode({
            "id_facility": int.parse(facilityId),
            "rate": userRate.toString()
          }));
      final responseData = json.decode(response.body);
      if (responseData['Error'] != null) {
        return responseData['Error'];
      } else {
        return 'your rate was added';
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> addReview(String facilityId, String userReview) async {
    final API = localApi + 'api/user/comment';
    var url = Uri.parse(API);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    String token = extractedData['token'];

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer" + " " + token
    };
    try {
      final response = await http.post(url,
          headers: headers,
          body: json.encode({
            "id_facility": int.parse(facilityId),
            "comment": userReview
          }));
      final responseData = json.decode(response.body);
      if (responseData['Error'] != null) {
        return responseData['Error'];
      } else {
        return 'your review was added';
      }
    } catch (e) {
      print(e);
    }
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      ReviewModel(
          id_facility: json['id_facility'].toString(),
          rate: json["rate"] == null ? 1 : json["rate"].toDouble(),
          id_user: json['id_user'].toString(),
          id: json['id'].toString(),
          comment: json['comment'].toString(),
          name: json['user']['name'].toString(),
          path_photo: json['user']['path_photo'].toString(),
          time: json['created_at'].toString());
}
