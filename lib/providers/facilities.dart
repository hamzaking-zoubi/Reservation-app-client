import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rhrs_app/constants.dart';
import 'package:rhrs_app/models/facility.dart';
import 'package:http/http.dart' as http;
import 'package:rhrs_app/models/facility_photo.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Facilities extends ChangeNotifier {
  String nextUrl;
  List<Facility> _facilities = [
    /*Facility(
        id: '1',
        name: 'anas\'s resort',
        location: 'Damascus',
        description: 'really nice view with such a beautiful infrastructure.',
        cost: 70,
        facilityImages: [
          AssetImage('assets/images/facility.jpg'),
        ],
        numberOfGuets: 4,
        numberOfRooms: 5,
        facilityType: FacilityType.RESORT,
        rate: 4),
    Facility(
        id: '2',
        name: 'ameer\'s resort',
        location: 'Latakia',
        description: 'really nice view with such a beautiful infrastructure.',
        cost: 85,
        facilityImages: [
          AssetImage('assets/images/facility.jpg'),
        ],
        numberOfGuets: 4,
        numberOfRooms: 5,
        facilityType: FacilityType.CHALET,
        rate: 5),*/
  ];

  List<Facility> savedFacilities = [];
  List<Facility> top5Resort = [];
  List<Facility> top5Chalet = [];
  List<Facility> top5Hostels = [];
  List<Facility> recommendedFacilities = [];
  Facility fetchedFacility;

  Future<void> fetchSavedFacilities() async {
    savedFacilities = [];
    final API = localApi + 'api/favorite/index';
    var url = Uri.parse(API);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('token'));
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    String token = extractedData['token'];
    print('user id');
    print(extractedData['userId']);
    print(token);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer" + " " + token
    };
    try {
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body);
      print(extractedData['Data']);
      final data = (extractedData['Data'] as List)
          .map((data) => Facility(
                id: data['id'].toString(),
                name: data['name'],
                type: data['type'],
                description: data['description'],
                rate: data['rate'],
                cost: data['cost'],
                location: data['location'],
                hasCoffee: true,
                //data['coffee_machine'] == 0 ? false : true,
                hasCondition: true,
                //data['air_condition'] == 0 ? false : true,
                hasFridge: true,
                //data['fridge'] == 0 ? false : true,
                hasWifi: data['wifi'] == 0 ? false : true,
                hasTv: true,
                //data['tv'] == 0 ? false : true,
                facilityImages: List.from(data['photos']).length > 0
                    ? (data['photos'] as List)
                        .map((photo) => FacilityPhoto(
                            photoId: photo['id'],
                            facilityId: photo['id_facility'],
                            photoPath: photo[
                                'path_photo'] /* != null
                                  ? photo['path_photo']
                                  : 'https://trekbaron.com/wp-content/uploads/2020/07/types-of-resorts-July282020-1-min.jpg',*/
                            ))
                        .toList()
                    : [
                        FacilityPhoto(
                          photoId: 1,
                          photoPath:
                              'https://prod-palace-brand.s3.amazonaws.com/medium_playa_del_carmen_resort_7769c7222e.jpg',
                        )
                      ],
              ))
          .toList();
      savedFacilities.addAll(data);
      print(savedFacilities[0].facilityImages);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> fetchNextMatched(
      {String startDate,
      String endDate,
      int minCost,
      int maxCost,
      int rate,
      String propertyType,
      String location}) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var queryParameters = {
      "type[]": propertyType,
      //"type": propertyType,
      "cost1": '$minCost',
      "cost2": '$maxCost',
      "rate": '$rate',
      "start_date": "$startDate",
      "end_date": "$endDate",
      "location": "$location",
    };
    final List<Facility> _loadedFacilities = [];
    final pageNumber = nextUrl.substring(27, 56);
    print('page number $pageNumber');

    try {
      final uri = Uri.http(
          apiWithParams /*'192.168.43.55:8000'*/, pageNumber, queryParameters);
      final response = await http.get(uri, headers: headers);
      final extractedData = json.decode(response.body);
      print(response.body);
      final data = (extractedData['facilities'] as List)
          .map((data) => Facility(
                id: data['id'].toString(),
                ownerId: data['id_user'].toString(),
                name: data['name'],
                type: data['type'] == 'farmer' ? 'Resort' : data['type'],
                description: data['description'],
                rate: data['rate'],
                cost: data['cost'],
                location: data['location'],
                hasCoffee: true,
                //data['coffee_machine'] == 0 ? false : true,
                hasCondition: true,
                //data['air_condition'] == 0 ? false : true,
                hasFridge: true,
                //data['fridge'] == 0 ? false : true,
                hasWifi: data['wifi'] == 0 ? false : true,
                hasTv: true,
                //data['tv'] == 0 ? false : true,
                facilityImages: (data['photos'] as List)
                    .map((photo) => FacilityPhoto(
                        photoId: photo['id'],
                        facilityId: photo['id_facility'],
                        photoPath: photo['path_photo']))
                    .toList(),
              ))
          .toList();
      nextUrl = extractedData['url_next_page'];
      _loadedFacilities.addAll(data);
      print('\ntotal :  ${extractedData['total_items']}\n');
      //print('length : ${_facilities.length}');
      _facilities.addAll(_loadedFacilities);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> fetchMatchedFacilities(
      {String startDate,
      String endDate,
      int minCost,
      int maxCost,
      int rate,
      String propertyType,
      String location}) async {
    double min = minCost.toDouble();
    double max = maxCost.toDouble();
    print(startDate);
    print(endDate);
    var queryParameters = {
      "type[]": propertyType,
      //"type": propertyType,
      "cost1": '$minCost',
      "cost2": '$maxCost',
      "rate": '$rate',
      "start_date": "$startDate",
      "end_date": "$endDate",
      "location":"$location",
    };
    //DateTime
    print(queryParameters);
    print(minCost);
    print(maxCost);
    print(rate);
    print('anas');
    Map<String, String> headers = {
      // 'Content-Type': 'multipart/form-data',
      //'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    /*final uri = Uri.http('laravelapimk.atwebpages.com',
        '/public/api/facilities/search', queryParameters);*/
    final uri = Uri.http(apiWithParams /*'192.168.43.55:8000'*/,
        '/api/facilities/search', queryParameters);
    final List<Facility> _loadedFacilities = [];

    try {
      print('anas3');
      final response = await http.get(uri, headers: headers);
      final extractedData = json.decode(response.body);
      print(response.body);
      final data = (extractedData['facilities'] as List)
          .map((data) => Facility(
                id: data['id'].toString(),
                ownerId: data['id_user'].toString(),
                name: data['name'],
                type: data['type'] == 'farmer' ? 'Resort' : data['type'],
                description: data['description'],
                rate: data['rate'],
                cost: data['cost'],
                location: data['location'],
                hasCoffee: true,
                //data['coffee_machine'] == 0 ? false : true,
                hasCondition: true,
                //data['air_condition'] == 0 ? false : true,
                hasFridge: true,
                //data['fridge'] == 0 ? false : true,
                hasWifi: data['wifi'] == 0 ? false : true,
                hasTv: true,
                //data['tv'] == 0 ? false : true,
                facilityImages: (data['photos'] as List)
                    .map((photo) => FacilityPhoto(
                        photoId: photo['id'],
                        facilityId: photo['id_facility'],
                        photoPath: photo['path_photo']))
                    .toList(),
              ))
          .toList();
      nextUrl = extractedData['url_next_page'];
      print('next url : $nextUrl');
      print('first total :  ${extractedData['total_items']}\n');
      _loadedFacilities.addAll(data);
      _facilities = _loadedFacilities;
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> fetchTop5(String facilityType) async {
    //top5Facilities = [];
    final queryParameters = {
      "type[]": facilityType,
    };
    //final API = localApi + 'api/user/top5rate';
    //var url = Uri.parse(API);
    final uri = Uri.http(apiWithParams, '/api/user/top5rate', queryParameters);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('token'));
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    String token = extractedData['token'];
    print('user id');
    print(extractedData['userId']);
    print(token);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer" + " " + token
    };
    try {
      final response = await http.get(uri, headers: headers);
      final extractedData = json.decode(response.body);
      print(extractedData);
      final data = (extractedData as List)
          .map((data) => Facility(
                id: data['id'].toString(),
                name: data['name'],
                type: data['type'],
                description: data['description'],
                rate: data['rate'],
                cost: data['cost'],
                location: data['location'],
                hasCoffee: true,
                //data['coffee_machine'] == 0 ? false : true,
                hasCondition: true,
                //data['air_condition'] == 0 ? false : true,
                hasFridge: true,
                //data['fridge'] == 0 ? false : true,
                hasWifi: data['wifi'] == 0 ? false : true,
                hasTv: true,
                //data['tv'] == 0 ? false : true,
                facilityImages: List.from(data['photos']).length > 0
                    ? (data['photos'] as List)
                        .map((photo) => FacilityPhoto(
                            photoId: photo['id'],
                            facilityId: photo['id_facility'],
                            photoPath: photo[
                                'path_photo'] /* != null
                                  ? photo['path_photo']
                                  : 'https://trekbaron.com/wp-content/uploads/2020/07/types-of-resorts-July282020-1-min.jpg',*/
                            ))
                        .toList()
                    : [
                        FacilityPhoto(
                          photoId: 1,
                          photoPath:
                              'https://prod-palace-brand.s3.amazonaws.com/medium_playa_del_carmen_resort_7769c7222e.jpg',
                        )
                      ],
              ))
          .toList();
      if (facilityType == 'farmer') {
        top5Resort = [];
        top5Resort.addAll(data);
      } else if (facilityType == 'chalet') {
        top5Chalet = [];
        top5Chalet.addAll(data);
      } else if (facilityType == 'hostel') {
        top5Hostels = [];
        top5Hostels.addAll(data);
      }
    } catch (e) {
      print("top 5 " + e.toString());
    }
    //print('length ${top5Facilities.length}');
    //notifyListeners();
  }

  Future<void> fetchRecommended() async {
    recommendedFacilities = [];
    final API = localApi + 'api/user/proposals';
    var url = Uri.parse(API);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('token'));
    final extractedData =
    json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    String token = extractedData['token'];
    print('user id');
    print(extractedData['userId']);
    print(token);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer" + " " + token
    };
    try {
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body);
      print(extractedData);
      final data = (extractedData as List)
          .map((data) => Facility(
        id: data['id'].toString(),
        name: data['name'],
        type: data['type'],
        description: data['description'],
        rate: data['rate'],
        cost: data['cost'],
        location: data['location'],
        hasCoffee: true,
        //data['coffee_machine'] == 0 ? false : true,
        hasCondition: true,
        //data['air_condition'] == 0 ? false : true,
        hasFridge: true,
        //data['fridge'] == 0 ? false : true,
        hasWifi: data['wifi'] == 0 ? false : true,
        hasTv: true,
        //data['tv'] == 0 ? false : true,
        facilityImages: List.from(data['photos']).length > 0
            ? (data['photos'] as List)
            .map((photo) => FacilityPhoto(
            photoId: photo['id'],
            facilityId: photo['id_facility'],
            photoPath: photo[
            'path_photo'] /* != null
                                  ? photo['path_photo']
                                  : 'https://trekbaron.com/wp-content/uploads/2020/07/types-of-resorts-July282020-1-min.jpg',*/
        ))
            .toList()
            : [
          FacilityPhoto(
            photoId: 1,
            photoPath:
            'https://prod-palace-brand.s3.amazonaws.com/medium_playa_del_carmen_resort_7769c7222e.jpg',
          )
        ],
      ))
          .toList();
      print(data);
      recommendedFacilities.addAll(data);
    } catch (e) {
      print("recommended " + e.toString());
    }
    //print('length ${top5Facilities.length}');
    //notifyListeners();
  }

  Future<List<String>> getUnavailableDates(String facilityId) async {
    List<String> dates = [];
    List<List<String>> allDates = [];

    final queryParameters = {"id_facility": int.parse(facilityId)};
    final uri = Uri.http(apiWithParams, '/api/bookings/dates', queryParameters.map((key, value) => MapEntry(key, value.toString())));

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
      print('anas');
      final extractedData = await json.decode(response.body);
      print(extractedData);
      //print(extractedData['bookings']['start_date']);
      //print(extractedData['bookings']['end_date']);
      if(extractedData['bookings'] != null){
        print(extractedData['bookings']);
        /*final data = (extractedData as List)
            .map((data) {
              dates[0] = extractedData['bookings']['start_date'];
              dates[1] = extractedData['bookings']['end_date'];
        }).toList();*/
        //allDates.addAll(dates);
        //print(extractedData['bookings']['id_booking'].toString());
        final start = (extractedData['bookings'][0]['start_date']).toString().substring(0,10);
        final end = (extractedData['bookings'][0]['end_date']).toString().substring(0,10);
        //print(data);
        //allDates.add(data);
        dates.add(start);
        dates.add(end);
        print('dgdfg');
        print(dates);
        return dates;
      }
    } catch (e) {
      print("hgyfyug $e");
    }
  }

  Future<Facility> getFacilityDetails(String facilityId) async {
    final url = localApi + 'api/facility/show/$facilityId';

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
      final response = await http.get(Uri.parse(url), headers: headers);
      final extractedData = json.decode(response.body);
      print(extractedData);
      final data = Facility(
        id: extractedData['Data']['id'].toString(),
        ownerId: extractedData['Data']['id_user'].toString(),
        name: extractedData['Data']['name'],
        type: extractedData['Data']['type'],
        description: extractedData['Data']['description'],
        rate: extractedData['Data']['rate'],
        cost: extractedData['Data']['cost'],
        location: extractedData['Data']['location'],
        hasCoffee: true,
        //data['coffee_machine'] == 0 ? false : true,
        hasCondition: true,
        //data['air_condition'] == 0 ? false : true,
        hasFridge: true,
        //data['fridge'] == 0 ? false : true,
        hasWifi: extractedData['Data']['wifi'] == 0 ? false : true,
        hasTv: true,
        //data['tv'] == 0 ? false : true,
        facilityImages: List.from(extractedData['Data']['photos']).length > 0
            ? (extractedData['Data']['photos'] as List).map((photo) =>
                FacilityPhoto(
                    photoId: photo['id'],
                    facilityId: photo['id_facility'],
                    photoPath: photo[
                        'path_photo'] /* != null
                                  ? photo['path_photo']
                                  : 'https://trekbaron.com/wp-content/uploads/2020/07/types-of-resorts-July282020-1-min.jpg',*/
                    )).toList()
            : [
                FacilityPhoto(
                  photoId: 1,
                  photoPath:
                      'https://prod-palace-brand.s3.amazonaws.com/medium_playa_del_carmen_resort_7769c7222e.jpg',
                )
              ],
      );
      print('dfdghdfg');
      fetchedFacility = data;
      print(fetchedFacility);
      return fetchedFacility;
      print(fetchedFacility);
    } catch (e) {
      print('fetched   ${e.toString()}');
    }
  }

  Facility findById(String id) {
    return _facilities.firstWhere((facility) => facility.id == id);
  }

  List<Facility> get facilities => _facilities;
}
