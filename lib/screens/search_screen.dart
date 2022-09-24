import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rhrs_app/screens/facilities_list.dart';
import '../constants.dart';
import '../widgets/custom_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rhrs_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/searchScreen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  RangeValues _currentRangeValues = const RangeValues(40, 300);
  final GlobalKey<FormState> _queryFormKey = GlobalKey();
  String facilityAddress;
  int _rate = 1;
  DateTime _reservationStartDate;
  DateTime _reservationEndDate;
  int cost = 10;
  bool isChalet = false;
  bool isResort = false;
  bool isHostel = false;

  String getType() {
    if (isChalet) {
      return 'chalet';
    } else if (isResort) {
      return 'farmer';
    } else if (isHostel) {
      return 'hostel';
    }
    return "";
  }

  CheckboxListTile buildCheckboxListTile(
      String title, String subtitle, bool propertyType) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
      value: propertyType,
      onChanged: (newVal) {
        setState(() {
          propertyType = newVal;
          if (title == 'Resort' || title == 'مزرعة')
            isResort = propertyType;
          else if (title == 'Chalet' || title == 'شاليه')
            isChalet = propertyType;
          else
            isHostel = propertyType;
        });
      },
      activeColor: Colors.black,
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14),
      ),
    );
  }

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

  void pickStartReservationDate() {
    showDatePicker(
            builder: (ctx, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: kPrimaryColor,
                    onPrimary: Colors.white,
                    onSurface: Colors.blueAccent,
                  ),
                ),
                child: child,
              );
            },
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2023))
        .then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _reservationStartDate = pickedDate;
        print(_reservationStartDate.toString().substring(0, 10));
      });
    });
  }

  void pickEndReservationDate() {
    showDatePicker(
            builder: (ctx, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: kPrimaryColor, // <-- SEE HERE
                    onPrimary: Colors.white, // <-- SEE HERE
                    onSurface: Colors.blueAccent, // <-- SEE HERE
                  ),
                ),
                child: child,
              );
            },
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2023))
        .then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        if (!pickedDate.isBefore(_reservationStartDate))
          _reservationEndDate = pickedDate;
        else
          _showErrorDialog(LocaleKeys.endDateBeforeStartError.tr());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.search.tr()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Form(
                  key: _queryFormKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: TextFormField(
                          onChanged: (newValue) {
                            facilityAddress = newValue;
                          },
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.facilityLocation.tr(),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      LocaleKeys.from.tr(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: pickStartReservationDate,
                      child: Text(
                        _reservationStartDate == null
                            ? LocaleKeys.chooseStartDate.tr()
                            : DateFormat.yMd()
                                .format(_reservationStartDate)
                                .toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor),
                      ),
                    ),
                    Text(
                      LocaleKeys.to.tr(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: pickEndReservationDate,
                      child: Text(
                        _reservationEndDate == null
                            ? LocaleKeys.chooseEndDate.tr()
                            : DateFormat.yMd()
                                .format(_reservationEndDate)
                                .toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                LocaleKeys.cost.tr(),
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Theme.of(context).accentColor,
                  inactiveTrackColor: Color(0xFF8D8E98),
                  thumbColor: Theme.of(context).primaryColor,
                  overlayColor: Color(0x29EB1555),
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 10.0,
                  ),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: 22.0,
                  ),
                ),
                child: RangeSlider(
                  values: _currentRangeValues,
                  max: 1000,
                  divisions: 1000,
                  labels: RangeLabels(
                    _currentRangeValues.start.round().toString(),
                    _currentRangeValues.end.round().toString(),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _currentRangeValues = values;
                    });
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      LocaleKeys.rate.tr(),
                      style: TextStyle(fontSize: 18),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        IconButton(
                            icon: Icon(FontAwesomeIcons.minus),
                            onPressed: () {
                              setState(() {
                                if (_rate > 1 && _rate <= 5) _rate--;
                              });
                            }),
                        Text(
                          '$_rate',
                          style: TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.plus),
                          onPressed: () {
                            setState(() {
                              if (_rate >= 1 && _rate < 5) _rate++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                LocaleKeys.propertyType.tr(),
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              buildCheckboxListTile(LocaleKeys.chalet.tr(),
                  LocaleKeys.chaletReserve.tr(), isChalet),
              buildCheckboxListTile(LocaleKeys.resort.tr(),
                  LocaleKeys.resortReserve.tr(), isResort),
              buildCheckboxListTile(LocaleKeys.hostel.tr(),
                  LocaleKeys.hostelReserve.tr(), isHostel),
              SizedBox(
                height: 10,
              ),
              Center(
                child: CustomButton(
                    buttonLabel: LocaleKeys.search.tr(),
                    onPress: () async {
                      if (facilityAddress == null) {
                        _showErrorDialog(LocaleKeys.enterFacilityLocation.tr());
                      } else if (!isChalet && !isResort && !isHostel) {
                        _showErrorDialog(LocaleKeys.chooseType.tr());
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => FacilitiesList(
                                      location: facilityAddress,
                                      start: _reservationStartDate
                                          .toString()
                                          .substring(0, 10),
                                      end: _reservationEndDate
                                          .toString()
                                          .substring(0, 10),
                                      rate: _rate,
                                      facilityType: getType(),
                                      maxCost: _currentRangeValues.end.round(),
                                      minCost:
                                          _currentRangeValues.start.round(),
                                    )));
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}