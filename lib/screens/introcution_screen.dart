import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rhrs_app/models/auth.dart';
import 'package:rhrs_app/screens/Navigation_bar.dart';
import 'package:rhrs_app/screens/search_screen.dart';
import 'package:rhrs_app/widgets/intro_page.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 2;
            });
          },
          children: [
            IntroPage('assets/images/hostel1.jpg'),
            Container(child: Center(child: Text('Screen 2')),),
            Container(child: Center(child: Text('Screen 3')),),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  primary: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  minimumSize: const Size.fromHeight(60)),
              onPressed: () async{
                /*final prefs = await SharedPreferences.getInstance();
                prefs.setBool('showHome', true);*/
                Navigator.pushReplacementNamed(context, Auth.routeName);
              },
              child: const Text(
                'Get Started',
                style: TextStyle(fontSize: 24),
              ),
      )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        controller.jumpToPage(2);
                      },
                      child: Text('Skip',style: TextStyle(fontSize: 18),),),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                          spacing: 16,
                          dotColor: Colors.black26,
                          activeDotColor: Theme.of(context).primaryColor),
                      onDotClicked: (index) => controller.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      child: Text('Next',style: TextStyle(fontSize: 18),)),
                ],
              ),
            ),
    );
  }
}
