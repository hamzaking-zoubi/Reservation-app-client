import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhrs_app/components/details%20extension.dart';
import 'package:rhrs_app/models/facility.dart';
import 'package:rhrs_app/models/facility_photo.dart';
import 'package:rhrs_app/models/review.dart';
import 'package:rhrs_app/providers/facilities.dart';
import 'package:rhrs_app/providers/pusherController.dart';
import 'package:rhrs_app/widgets/review_widget.dart';
import 'package:rhrs_app/widgets/travel_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../providers/Reviews.dart';
import 'package:rhrs_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

import '../constants.dart';

class NewDetailsScreen extends StatefulWidget {
  static const routeName = '/Details';

  final List<FacilityPhoto> facilityImages;
  final String facilityType;
  final String facilityName;
  final int rate;
  final String description;
  final int cost;
  final String location;
  final bool hasWifi;
  final bool hasCoffee;
  final bool hasCondition;
  final bool hasFridge;
  final bool hasTv;
  String id;
  final String ownerId;
  PickerDateRange selectedBookingDate;
  int numberOfBookedDays = 0;
  String reportContent;
  String messageContent;
  int userRate = 1;
  String userReview;

  NewDetailsScreen(
      {this.id,
      this.ownerId,
      this.rate,
      this.facilityType,
      this.description,
      this.cost,
      this.facilityName,
      this.facilityImages,
      this.location,
      this.hasWifi,
      this.hasCoffee,
      this.hasCondition,
      this.hasFridge,
      this.hasTv});

  @override
  _NewDetailsScreenState createState() => _NewDetailsScreenState();
}

class _NewDetailsScreenState extends State<NewDetailsScreen> {
  bool isLoading = false;

  List<String> getAmenities() {
    List<String> amenities = [];
    if (widget.hasFridge) amenities.add('Fridge');
    if (widget.hasCondition) amenities.add('Condition');
    if (widget.hasCoffee) amenities.add('Coffee');
    if (widget.hasTv) amenities.add('TV');
    if (widget.hasWifi) amenities.add('Wifi');
    return amenities;
  }

  bool isInit = true;
  List<String> dates = [];
  Reviews reviews;
  Facility facility;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 300)).then((value) async {
      dates = await Provider.of<Facilities>(context, listen: false)
          .getUnavailableDates(widget.id);
      print('dates : $dates');
      final review = Provider.of<Reviews>(context, listen: false);
      controller.addListener(() {
        if (controller.position.maxScrollExtent == controller.offset) {
          if (review.url_next_page != null) {
            review.fetchNextReview().then((value) {});
          }
        }
      });
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final facilityId = widget.id;
      /*facility =
          Provider.of<Facilities>(context, listen: false).findById(facilityId);*/
      reviews = Provider.of<Reviews>(context, listen: false);
      reviews.setChannelName("User.Comment.Facility.${widget.id}");
      reviews.setEventName("CommentEvent");
      reviews.subscribePusher();
    }
    isInit = false;

    super.didChangeDependencies();
  }

  //to be moved to a logic class
  Future<String> submitReport() async {
    print('submit');
    /*setState(() {
      isLoading = true;
    });*/
    final API = localApi + 'api/report/add';
    var url = Uri.parse(API);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('token'));
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    String token = extractedData['token'];

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer" + " " + token
    };

    try {
      print('before');
      final response = await http.post(url,
          headers: headers,
          body: json.encode(
              {"id_facility": widget.id, "report": widget.reportContent}));
      print('after');
      print(response.body.contains('Error'));
      //final extractedData = await json.decode(response.body);
      print(extractedData);
      setState(() {
        isLoading = false;
      });
      if (response.body.contains('Error')) {
        return 'An error occured when reporting';
      } else {
        return 'reporting done successfully';
      }
    } catch (e) {
      print('report $e');
      /*setState(() {
        isLoading = false;
      });*/
    }
  }

  //to be moved to a logic class
  Future<void> openChatDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(LocaleKeys.messageToOwner.tr()),
            content: TextField(
              maxLines: 4,
              onSubmitted: (value) {
                widget.messageContent = value;
                print('report : ${widget.reportContent}');
              },
              decoration: InputDecoration(
                hintText: LocaleKeys.enterMessage.tr(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              keyboardType: TextInputType.text,
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  print('owner id            :         ${widget.ownerId}');
                  Provider.of<PusherController>(context, listen: false)
                      .sendMessage(widget.messageContent, widget.ownerId);
                  Navigator.pop(context);
                  /*String result = await submitReport();
              Navigator.pop(context);
              _showErrorDialog(result);*/
                },
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        LocaleKeys.send.tr(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
              ),
            ],
          ));

  Future<void> openReportDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(LocaleKeys.reportToAdmin.tr()),
            content: TextField(
              maxLines: 4,
              onSubmitted: (value) {
                widget.reportContent = value;
                print('report : ${widget.reportContent}');
              },
              decoration: InputDecoration(
                hintText: LocaleKeys.reportReason.tr(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              keyboardType: TextInputType.text,
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  String result = await submitReport();
                  Navigator.pop(context);
                  _showErrorDialog(result ?? LocaleKeys.reportFail.tr());
                },
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        LocaleKeys.submit.tr(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
              ),
            ],
          ));

  void _showErrorDialog(String error) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(LocaleKeys.error.tr()),
              content: Text(error),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(LocaleKeys.ok.tr()))
              ],
            ));
  }

  //to be moved to a logic class
  Future<bool> reserveFacility(
      {String facilityId, String startDate, String endDate}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    String authToken = extractedData['token'];
    String token = "Bearer" + " " + authToken;
    var url = Uri.parse(localApi + "api/bookings/booking");

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': token
    };

    try {
      final response = await http.post(url,
          headers: headers,
          body: json.encode({
            "id_facility": facilityId,
            "start_date": startDate,
            "end_date": endDate
          }));
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

  void _showPaymentConfirmation() {
    widget.numberOfBookedDays = widget.selectedBookingDate.endDate
            .difference(widget.selectedBookingDate.startDate)
            .inDays +
        1;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Payment Confirmation'),
              content: Text(
                  'This will cost you ${widget.numberOfBookedDays * widget.cost}\$ , Are you sure you want to book?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Ok'))
              ],
            ));
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    widget.selectedBookingDate = args.value;
    print(widget.selectedBookingDate);
  }

  /*List<DateTime> getDaysInBetween() {
    List<DateTime> days = [];
    for (int i = 0;
        i <=
            DateTime.parse(dates[0])
                .difference(DateTime.parse(dates[1]))
                .inDays;
        i++) {
      days.add(DateTime.parse(dates[0]).add(Duration(days: i)));
    }
    print(days);
    return days;
  }*/

//  void pickStartReservationDate() {
//    //not used
//    showDateRangePicker(
//            builder: (ctx, child) {
//              return Theme(
//                data: Theme.of(context).copyWith(
//                  colorScheme: ColorScheme.light(
//                    primary: kPrimaryColor, // <-- SEE HERE
//                    onPrimary: Colors.white, // <-- SEE HERE
//                    onSurface: Colors.blueAccent, // <-- SEE HERE
//                  ),
//                ),
//                child: child,
//              );
//            },
//            context: context,
//            //initialDate: DateTime.now(),
//            firstDate: DateTime.now(),
//            lastDate: DateTime(2023))
//        .then((pickedDate) {
//      if (pickedDate == null) return;
//      /*setState(() {
//        _reservationStartDate = pickedDate;
//        print(_reservationStartDate.toString().substring(0, 10));
//      });*/
//    });
//  }

  void pickReservationDate() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(LocaleKeys.selectBookingDates.tr()),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(LocaleKeys.cancel.tr())),
              TextButton(
                  onPressed: () async {
                    //Navigator.of(context).pop();
                    final canBeReserved = await reserveFacility(
                        facilityId: widget.id,
                        startDate: widget.selectedBookingDate.startDate
                            .toString()
                            .substring(0, 10),
                        endDate: widget.selectedBookingDate.endDate
                            .toString()
                            .substring(0, 10));
                    Navigator.pop(context);
                    canBeReserved
                        ? _showErrorDialog(LocaleKeys.reservationDone.tr())
                        : _showErrorDialog(LocaleKeys.reservationError.tr());
                  },
                  child: Text('Ok'))
            ],
            content: Container(
              width: 300,
              height: 300,
              child: SfDateRangePicker(
                //rangeSelectionColor: kPrimaryColor,
                selectionColor: kPrimaryColor,
                endRangeSelectionColor: kPrimaryColor,
                startRangeSelectionColor: kPrimaryColor,
                view: DateRangePickerView.month,
                enablePastDates: false,
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                maxDate: DateTime(2023, 03, 25, 10, 0, 0),
                monthCellStyle: DateRangePickerMonthCellStyle(
                    blackoutDatesDecoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(width: 1),
                        shape: BoxShape.circle)),
                /*monthViewSettings: DateRangePickerMonthViewSettings(
                    blackoutDates:
                        getDaysInBetween() /* [
                      getDaysInBetween()
                      /*DateTime(2022, 08, 12),
                      DateTime(2022, 08, 11)*/
                    ]*/
                    ),*/
              ),
            ),
          );
          /*SfDateRangePicker(
      view: DateRangePickerView.year,
      enablePastDates : false,
      onSelectionChanged: _onSelectionChanged,
      selectionMode: DateRangePickerSelectionMode.range,
      maxDate: DateTime(2023, 03, 25, 10 , 0, 0),
      monthViewSettings: DateRangePickerMonthViewSettings(blackoutDates:[DateTime(2020, 03, 18), DateTime(2020, 03, 19)]),
    );*/
        });
  }

  final controller = PageController();
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final _dtlPriceTextStyle = Theme.of(context)
        .textTheme
        .headline3
        .copyWith(color: kBackgroundLightColor, fontWeight: FontWeight.w500);

    final _dtlSubTextStyle = Theme.of(context)
        .textTheme
        .headline5
        .copyWith(color: kBackgroundLightColor, fontWeight: FontWeight.normal);

    final _dtlButtonTextStyle = Theme.of(context).textTheme.headline6.copyWith(
        color: kPrimaryColor, fontWeight: FontWeight.w600, fontSize: 14);

    return Scaffold(
      appBar: null,
      body: Column(children: [
        Expanded(
          child: Stack(children: [
            PageView.builder(
              itemCount: widget.facilityImages.length,
              controller: controller,
              itemBuilder: (ctx, value) => Container(
                height: screenHeight / 2,
                width: screenWidth,
                child: SafeArea(
                  child: Image(
                    image: //AssetImage('assets/images/facility.jpg'),
                        NetworkImage(localApi +
                            widget.facilityImages[value]
                                .photoPath /*'assets/images/facility.jpg'*/),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SafeArea(
                      child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                    Row(
                      children: [
                        SafeArea(
                          child: IconButton(
                              icon: Icon(
                                Icons.report,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                await openReportDialog();
                              }),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SafeArea(
                          child: IconButton(
                              icon: Icon(
                                Icons.chat,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                await openChatDialog();
                              }),
                        ),
                      ],
                    )
                  ]),
            ),
          ]),
        ),
        Expanded(
          //color: Colors.white,
          child: SingleChildScrollView(
            child: Column(children: [
              DetailExtension(
                id: widget.id,
                facilityType: widget.facilityType,
                description: widget.description,
                name: widget.facilityName,
                rate: widget.rate,
                location: widget.location,
                //amenities: getAmenities(),
                hasWifi: widget.hasWifi,
                hasTv: widget.hasTv,
                hasFridge: widget.hasFridge,
                hasCondition: widget.hasCondition,
                hasCoffee: widget.hasCoffee,
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Divider(),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                LocaleKeys.reviews.tr(),
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              RatingBar.builder(
                initialRating: 1,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 30,
                ),
                onRatingUpdate: (rating) async {
                  widget.userRate = rating.round();
                  String result =
                      await Provider.of<ReviewModel>(context, listen: false)
                          .addRate(widget.id, widget.userRate);
                  if (result.contains('evaluation')) {
                    _showErrorDialog(LocaleKeys.reserveBeforeRate.tr());
                  }
                  print(result);
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: TextField(
                  maxLines: 3,
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) async {
                    widget.userReview = value;
                    String result =
                        await Provider.of<ReviewModel>(context, listen: false)
                            .addReview(widget.id, widget.userReview);
                    if (result.contains('Dont make Rating')) {
                      _showErrorDialog(LocaleKeys.reserveBeforeReview.tr());
                    }
                    print(result);
                    print(widget.userReview);
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      labelText: 'Write a review...'),
                ),
              ),
              FutureBuilder(
                future: Provider.of<Reviews>(context, listen: false)
                    .fetchReview(widget.id),
                builder: ((ctx, resultSnapShot) => resultSnapShot
                            .connectionState ==
                        ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : Consumer<Reviews>(
                        builder: (ctx, fetchedReviews, child) =>
                            ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          controller: _controller,
                          itemBuilder: (context, index) {
                            if (index < fetchedReviews.review.length) {
                              return Review(
                                time: fetchedReviews.review[index].time,
                                id: fetchedReviews.review[index].id,
                                name: fetchedReviews.review[index].name,
                                rate: fetchedReviews.review[index].rate,
                                comment: fetchedReviews.review[index].comment,
                                id_facility:
                                    fetchedReviews.review[index].id_facility,
                                id_user: fetchedReviews.review[index].id_user,
                                path_photo:
                                    fetchedReviews.review[index].path_photo,
                              );
                            } else {
                              if (fetchedReviews.url_next_page != null) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 32.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                              return const SizedBox(
                                height: 0,
                              );
                            }
                          },
                          itemCount: fetchedReviews.review.length + 1,
                        ),
                      )),
              ),

              /* Review(),
              Review(),
              Review(),
              Review(),
              Review(),*/
            ]),
          ),
        ),
        Container(
          height: 65,
          child: Container(
            padding: PAD_SYM_H20,
            color: kPrimaryColor,
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(LocaleKeys.cost.tr()+'${widget.cost * 4000}', style: _dtlPriceTextStyle),
                  Text(LocaleKeys.night.tr(), style: _dtlSubTextStyle),
                  Spacer(),
                  RawMaterialButton(
                      elevation: 0,
                      fillColor: kBackgroundLightColor,
                      constraints: BoxConstraints(minHeight: 42, minWidth: 100),
                      onPressed: () => pickReservationDate(),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(LocaleKeys.bookNow.tr(), style: _dtlButtonTextStyle))
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
