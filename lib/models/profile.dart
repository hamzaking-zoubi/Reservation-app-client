import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rhrs_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends ChangeNotifier {
  final int id;
  final String userName;
  final String email;
  final String phone;
  final String age;
  final String gender;
  final int amount;
  final String profilePhoto;
  Profile myProfile;

  Profile(
      {this.id,
      this.age,
      this.gender,
      this.email,
      this.phone,
      this.userName,
      this.amount,
      this.profilePhoto});

  Future<void> fetchProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    String token = extractedData['token'];
    print(token);
    final url = Uri.parse(localApi + "api/profile/show");

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + token
    };
    try {
      final response = await http.get(url, headers: headers);
      final profileData = json.decode(response.body);
      print(response.body);
      print('-----------------------------------------------------');
      myProfile = Profile(
          id: profileData['profile']['id_user'] ?? 1,
          gender: profileData['profile']['gender'] ?? 'Male',
          phone: profileData['profile']['phone'].toString() ?? '+963937925594',
          age: profileData['profile']['age'] ?? '21',
          profilePhoto: profileData['profile']['path_photo'],
          amount: profileData['user']['amount'] ?? 1000,
          email: profileData['user']['email'] ?? 'anas@gmail.com',
          userName: profileData['user']['name'] ?? 'anas',
      );
       //notifyListeners();
    } catch (e) {
      print(e);
      print('got');
      myProfile = Profile();
    }
  }

  Future<void> updateProfile(
      String newName, String newEmail, String newPhone,String newAge, String newGender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    String token = extractedData['token'];
    final url = Uri.parse(localApi + "api/profile/update");

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + token
    };
    try {
      final response = await http.post(url,
          headers: headers,
          body: json.encode({
            "name": newName,
            "email": newEmail,
            "phone": newPhone,
            "age" : newAge,
            "gender" : newGender,
          }));
      print(response.body);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
