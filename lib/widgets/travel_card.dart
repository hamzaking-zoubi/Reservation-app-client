//Now we will create our custom widget card
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhrs_app/constants.dart';
import 'package:rhrs_app/models/facility.dart';
import 'package:rhrs_app/screens/test_details_screen.dart';
import '../providers/facilities.dart';

Widget travelCard(String imgUrl, String facilityName, String location,
    int rating, String id, context) {
  return Card(
    margin: EdgeInsets.only(right: 22.0),
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    elevation: 0.0,
    child: InkWell(
      onTap: () async {
        Facility fetched = await Provider.of<Facilities>(context, listen: false)
            .getFacilityDetails(id.toString());
        if (fetched != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => NewDetailsScreen(
                        id: fetched.id,
                        ownerId: fetched.ownerId,
                        facilityName: fetched.name,
                        cost: fetched.cost,
                        rate: fetched.rate,
                        description: fetched.description,
                        facilityImages: fetched.facilityImages,
                        facilityType: fetched.type,
                        //getFacilityType(facility.facilityType),
                        location: fetched.location,
                        hasCoffee: fetched.hasCoffee,
                        hasCondition: fetched.hasCondition,
                        hasFridge: fetched.hasFridge,
                        hasTv: fetched.hasTv,
                        hasWifi: fetched.hasWifi,
                      )));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: //AssetImage('assets/images/facility.jpg'),
                NetworkImage(localApi + imgUrl),
            fit: BoxFit.cover,
            scale: 2.0,
          ),
        ),
        width: 200.0,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  //this loop will allow us to add as many star as the rating
                  for (var i = 0; i < rating; i++)
                    Icon(
                      Icons.star,
                      color: Color(0xFFFE8C68),
                    ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facilityName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      location,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
