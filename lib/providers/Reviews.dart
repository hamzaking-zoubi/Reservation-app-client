import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rhrs_app/constants.dart';
import 'package:rhrs_app/models/review.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Reviews with ChangeNotifier {
  //final String authToken;
  List<ReviewModel> review = [];
  String url_next_page;
  PusherClient pusher;
  Channel channel;
  String channelName = "";
  String prevChannelName = "";
  String eventName = "";
  String id_facilit;
  Reviews(/*this.authToken, this.review*/);
  List<ReviewModel> get getData {
    return [...review];
  }
  Future<void> fetchNextReview() async {
    print(id_facilit);
    var API = await url_next_page + "&id_recipient=${id_facilit}";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('token'));
    final extractedData =
    json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    String token = extractedData['token'];
    var auth = "Bearer" + " " + token;
    Map<String, String> headers = {
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    print(auth);
    final List<ReviewModel> _loadReview = [];
    try {
      final response = await http.get(Uri.parse(API), headers: headers);
      final extractedData = json.decode(response.body);
      print(response.body);
      final data = (extractedData['reviews'] as List)
          .map((data) => ReviewModel.fromJson(data))
          .toList();
      url_next_page = extractedData['url_next_page'];
      _loadReview.addAll(data);
      print('\ntotal :  ${extractedData['total_items']}\n');
      //print('length : ${_facilities.length}');
      review.addAll(_loadReview);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
  Future<void> fetchReview(id_facility) async {
    id_facilit=id_facility;
    var API = localApi + "api/user/review/show?id_facility=${id_facility}";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('token'));
    final extractedData =
    json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    String token = extractedData['token'];
    var auth = "Bearer" + " " + token;

    Map<String, String> headers = {
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    // print(auth);
    final List<ReviewModel> _loadReview = [];

    try {
      print('anas3');
      final response = await http.get(Uri.parse(API), headers: headers);
      final extractedData = json.decode(response.body);
      //  print(response.body);
      final data = (extractedData['reviews'] as List)
          .map((data) => ReviewModel.fromJson(data))
          .toList();
      url_next_page = extractedData['url_next_page'];
      //   print('next url : $url_next_page');
      //print('first total :  ${extractedData['total_items']}\n');
      _loadReview.addAll(data);
      review = _loadReview;
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
  void setChannelName(String name) {
    channelName = name;
    print("channelName: ${channelName}");
  }
  void setEventName(String name) {
    eventName = name;
    print("eventName: ${eventName}");
  }
  Future<void> initPusher() async {
    PusherOptions options = PusherOptions(cluster: "ap2");
    pusher = PusherClient("98034be202413ea485fc", options,
        autoConnect: false, enableLogging: true);
  }
  void connectPusher() {
    pusher.connect();
  }
  void disconnectPusher() async {
    await channel.unbind(eventName);
    await pusher.unsubscribe(channelName);
    await pusher.disconnect();
  }
  void subscribePusher() async {
    await initPusher();
    connectPusher();
    channel =  pusher.subscribe(channelName);
    pusher.onConnectionStateChange((state) {
      log("previousState: ${state.previousState}, currentState: ${state
          .currentState}");
    });
    pusher.onConnectionError((error) {
      log("error: ${error.message}");
    });
    channel.bind(eventName, (last) {
      var data = json.decode(last.data.toString());
      if (last.data != null) {
        review.add(
            ReviewModel(
                id_facility: data["comment"]['id_facility'].toString(),
                rate: data["comment"]["rate"] == null ? 1 : data["comment"]["rate"].toDouble(),
                id_user:data["comment"]['id_user'].toString(),
                id: data["comment"]['id'].toString(),
                comment: data["comment"]['comment'].toString(),
                name: data['user']['name'].toString(),
                path_photo: data['user']['path'].toString(),
                time: data["comment"]['created_at'].toString()
            ));
        notifyListeners();
      }

      prevChannelName = eventName;
    });
  }
}
