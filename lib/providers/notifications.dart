import 'dart:convert';
import 'dart:math' as math;
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rhrs_app/models/notificationApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/notification.dart';

class Notifications extends ChangeNotifier {
  List<Notification1> notifications = [];

  PusherClient pusher;
  Channel channel;
  String channelName = "";
  String prevChannelName = "";
  String eventName = "";



  Future<void> initPusher() async {
    var endpoint = localApi + "api/broadcasting/auth";
    String authToken = await getToken();
    var auth = "Bearer" + " " + authToken;
    PusherAuth auth1 = PusherAuth(
      endpoint.trim().toString(),
      headers: {
        'Authorization': auth,
      },
    );
    PusherOptions options = PusherOptions(auth: auth1, cluster: "ap2");
    pusher = PusherClient("98034be202413ea485fc", options,
        autoConnect: false, enableLogging: true);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedData =
    json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    String authToken = extractedData['token'];
    return authToken;
  }

  Future<String> getMyId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedData =
    json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    String id = extractedData['userId'];
    return id;
  }

  void setChannelName(String name) {
    channelName = name;
    print("channelName: ${channelName}");
  }
  void setEventName(String name) {
    eventName = name;
    print("eventName: ${eventName}");
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
    setEventName("Illuminate\\Notifications\\Events\\BroadcastNotificationCreated".toString());
    var id=await getMyId();
    setChannelName("private-User.Notify.${id}");
    await initPusher();
    connectPusher();
    channel = await pusher.subscribe(channelName);
    pusher.onConnectionStateChange((state) {
      log("previousState: ${state.previousState}, currentState: ${state.currentState}");
    });
    pusher.onConnectionError((error) {
      log("error: ${error.message}");
    });
    channel.bind(eventName, (last) {
      var data = json.decode(last.data.toString());
      if (last.data != null) {
        print(data);
        var body=data["body"].toString();
        var header=data["header"].toString();

        var random = math.Random();
        int id1 = random.nextInt(100000);
        NotificationApi.showNotification(
            body: body,
            id: id1,
            title: header);
      }
      prevChannelName = eventName;
    });
  }


  Future<void> fetchNotifications() async {
    notifications = [];
    print('get');
    //final url = localApi + 'api/user/notifications';
    final queryParameters = {
      "type": "All" /*, "num_values": 50*/
    };
    final uri =
        Uri.http(apiWithParams, '/api/user/notifications', queryParameters);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('token'));
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    String token = extractedData['token'];
    print(token);

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer" + " " + token
    };

    try {
      final response = await http.get(uri, headers: headers);
      final extractedData = await json.decode(response.body);
      print(extractedData);
      final data = (extractedData['Notifications'] as List)
          .map((data) => Notification1(
              title: data['data']['header'],
              content: data['data']['body'],
              creationDate: data['data']['created_at'],
              notifyType: data['data']['Notify_type']))
          .toList();
      notifications.addAll(data);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
