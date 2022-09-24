import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rhrs_app/screens/Authentication_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class Auth with ChangeNotifier {
  static const routeName = '/Auth';
  var _token;
  var _userId;

  bool get isAuth {
    if (_token != null) {
      return true;
    }
    return false;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signIn(String email, String password) async {
    const API = localApi + 'api/auth/login';
    /*const API = 'http://192.168.43.181:8000/api/auth/login';*/
    Map<String, String> headers = {
      //'Content-Type': 'multipart/form-data',
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    http.Response response;
    try {
      response = await http.post(Uri.parse(API),
          headers: headers,
          encoding: Encoding.getByName("utf-8"),
          body: json.encode({
            "email": email,
            "password": password,
          }));

      var responseData = await json.decode(response.body);
      if (response.statusCode == 201) {
        _token = responseData['token'].toString();
        _userId = responseData['user']['id'].toString();
        print("============================================");
        print(_token);
        print(_userId);
        print("============================================");

        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'userId': _userId,
        });
        prefs.setString('userData', userData);
        print(_token);
        print(_userId);
        notifyListeners();
      }
      if (responseData['Error'] != null) {
        if (responseData['Error']['email'] != null) {
          throw responseData['Error']['email'].toString();
        } else if (responseData['Error']['password'] != null) {
          throw responseData['Error']['password'].toString();
        }
      }
      /*else if (responseData['Error']['password_c'] != null) {
        throw responseData['Error']['password_c'].toString();
      }*/
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password, String confirmPassword,
      String name) async {
    const API = localApi + 'api/auth/register';
    //const API = 'http://192.168.43.181:8000/api/auth/register';
    Map<String, String> headers = {
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    print(email);
    print(name);
    print(password);
    print(confirmPassword);
    http.Response response;
    try {
      response = await http.post(Uri.parse(API),
          headers: headers,
          body: json.encode({
            "name": name,
            "email": email,
            "password": password,
            "password_c": confirmPassword,
            // "amount":10,
            "rule": "0"
          }));
      var responseData = await json.decode(response.body);
      print(responseData);
      if (response.statusCode == 201) {
        _token = responseData['token'].toString();
        _userId = responseData['user']['id'].toString();
        print("============================================");
        print(_token);
        print(_userId);
        print("============================================");
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'userId': _userId,
        });
        prefs.setString('userData', userData);
        notifyListeners();
      }
    } catch (erorr) {
      print(erorr);
      throw erorr;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    notifyListeners();
    return true;
  }

  Future<void> logout(context) async {
    const API = localApi + 'api/auth/logout';
    //var API = 'http://192.168.43.181:8000/api/auth/logout';
    String tokenAuthorization = "Bearer" + " " + _token;

    Map<String, String> headers = {
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': tokenAuthorization
    };
    http.Response response;
    try {
      response = await http.delete(Uri.parse(API), headers: headers);
      var responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode == 201) {
        _token = null;
        _userId = null;
        final sharedPrefernces = await SharedPreferences.getInstance();
        sharedPrefernces.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AuthenticationScreen.routeName, (route) => false);
      }
    } catch (error) {
      print(error);
    }
  }
}
