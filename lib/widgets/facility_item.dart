import 'package:flutter/material.dart';
import 'package:rhrs_app/screens/facility_details_screen.dart';

class FacilityItem extends StatelessWidget {
  // HotelItem({Key? key, required this.hotel}) : super(key: key);

  //final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () {
        Navigator.pushNamed(context, DetailScreen.routeName);
          } /*=> Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (_) => HotelDetailPage.init(hotel.name),
        ),
      ),*/
      ,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(32),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/facility.jpg', //facility.img
                fit: BoxFit.fill,
                width: double.infinity,
                height: 240,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.only(top: 200),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      /*const Padding(
                        padding: EdgeInsets.all(8),
                        child: TicketRent(
                          color: primaryColor,
                          title: 'FOR RENT',
                        ),
                      ),*/
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          '\$70/night',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text(
                      'Grand Blue Resort', // facility name
                      style: titleTextStyle,
                    ),
                    subtitle: Text('Damascus'), // facility address
                    trailing: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                      child: Transform.rotate(
                        angle: 25 * 3.1416 / 180,
                        child: IconButton(
                          icon: const Icon(Icons.navigation),
                          onPressed: () {},
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle titleTextStyle = const TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);
