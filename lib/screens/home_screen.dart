import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhrs_app/providers/facilities.dart';
import 'package:rhrs_app/providers/notifications.dart';
import 'package:rhrs_app/screens/search_screen.dart';
import 'package:rhrs_app/translations/locale_keys.g.dart';
import '../widgets/travel_card.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';


class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<Notifications>(context, listen: false).subscribePusher();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                LocaleKeys.welcome.tr(),
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 26.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Raleway'),
                speed: const Duration(milliseconds: 350),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            LocaleKeys.destination.tr(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchScreen.routeName);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    LocaleKeys.searchBar.tr(),
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
          ),
          SizedBox(height: 30.0),
          DefaultTabController(
            length: 3,
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Color(0xFF555555),
                      labelColor: Theme.of(context).primaryColor,
                      labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      tabs: [
                        Tab(
                          text: LocaleKeys.resortsTab.tr(),
                        ),
                        Tab(
                          text: LocaleKeys.hostelsTab.tr(),
                        ),
                        Tab(
                          text: LocaleKeys.chaletsTab.tr(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 300.0,
                      child: TabBarView(
                        children: [
                          Container(
                            child: FutureBuilder(
                              future: Provider.of<Facilities>(context,
                                      listen: false)
                                  .fetchTop5('farmer'),
                              builder: ((ctx, resultSnapShot) => resultSnapShot
                                          .connectionState ==
                                      ConnectionState.waiting
                                  ? Center(child: CircularProgressIndicator())
                                  : Consumer<Facilities>(
                                      builder:
                                          (ctx, fetchedFacilities, child) =>
                                              ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return travelCard(
                                              /*localApi +*/
                                              fetchedFacilities
                                                  .top5Resort[index]
                                                  .facilityImages[0]
                                                  .photoPath,
                                              fetchedFacilities
                                                  .top5Resort[index].name,
                                              fetchedFacilities
                                                  .top5Resort[index].location,
                                              fetchedFacilities
                                                  .top5Resort[index].rate,
                                              fetchedFacilities
                                                  .top5Resort[index].id,
                                              context);
                                        },
                                        itemCount:
                                            fetchedFacilities.top5Resort.length,
                                      ),
                                    )),
                            ),
                          ),
                          Container(
                            child: FutureBuilder(
                              future: Provider.of<Facilities>(context,
                                      listen: false)
                                  .fetchTop5('hostel'),
                              builder: ((ctx, resultSnapShot) => resultSnapShot
                                          .connectionState ==
                                      ConnectionState.waiting
                                  ? Center(child: CircularProgressIndicator())
                                  : Consumer<Facilities>(
                                      builder:
                                          (ctx, fetchedFacilities, child) =>
                                              ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return travelCard(
                                              /*localApi +*/
                                              fetchedFacilities
                                                  .top5Hostels[index]
                                                  .facilityImages[0]
                                                  .photoPath,
                                              fetchedFacilities
                                                  .top5Hostels[index].name,
                                              fetchedFacilities
                                                  .top5Hostels[index].location,
                                              fetchedFacilities
                                                  .top5Hostels[index].rate,
                                              fetchedFacilities
                                                  .top5Hostels[index].id,
                                              context);
                                        },
                                        itemCount: fetchedFacilities
                                            .top5Hostels.length,
                                      ),
                                    )),
                            ),
                          ),
                          Container(
                            child: FutureBuilder(
                              future: Provider.of<Facilities>(context,
                                      listen: false)
                                  .fetchTop5('chalet'),
                              builder: ((ctx, resultSnapShot) => resultSnapShot
                                          .connectionState ==
                                      ConnectionState.waiting
                                  ? Center(child: CircularProgressIndicator())
                                  : Consumer<Facilities>(
                                      builder:
                                          (ctx, fetchedFacilities, child) =>
                                              ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return travelCard(
                                              /*localApi +*/
                                              fetchedFacilities
                                                  .top5Chalet[index]
                                                  .facilityImages[0]
                                                  .photoPath,
                                              fetchedFacilities
                                                  .top5Chalet[index].name,
                                              fetchedFacilities
                                                  .top5Chalet[index].location,
                                              fetchedFacilities
                                                  .top5Chalet[index].rate,
                                              fetchedFacilities
                                                  .top5Chalet[index].id,
                                              context);
                                        },
                                        itemCount:
                                            fetchedFacilities.top5Chalet.length,
                                      ),
                                    )),
                            ),
                          ),
                          /*Container(
                            child: FutureBuilder(
                              future: Provider.of<Facilities>(context,
                                  listen: false)
                                  .fetchRecommended(),
                              builder: ((ctx, resultSnapShot) => resultSnapShot
                                  .connectionState ==
                                  ConnectionState.waiting
                                  ? Center(child: CircularProgressIndicator())
                                  : Consumer<Facilities>(
                                builder:
                                    (ctx, fetchedFacilities, child) =>
                                    ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return travelCard(
                                          /*localApi +*/
                                            fetchedFacilities.recommendedFacilities[index]
                                                .facilityImages[0].photoPath,
                                            fetchedFacilities
                                                .recommendedFacilities[index].name,
                                            fetchedFacilities
                                                .recommendedFacilities[index].location,
                                            fetchedFacilities
                                                .recommendedFacilities[index].rate,
                                            fetchedFacilities
                                                .recommendedFacilities[index].id,
                                            context
                                        );
                                      },
                                      itemCount:
                                      fetchedFacilities.recommendedFacilities.length,
                                    ),
                              )),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
