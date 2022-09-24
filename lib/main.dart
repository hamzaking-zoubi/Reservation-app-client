import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rhrs_app/models/auth.dart';
import 'package:rhrs_app/models/facility.dart';
import 'package:rhrs_app/models/profile.dart';
import 'package:rhrs_app/providers/bookings.dart';
import 'package:rhrs_app/providers/facilities.dart';
import 'package:rhrs_app/providers/pusherController.dart';
import 'package:rhrs_app/screens/Authentication_screen.dart';
import 'package:rhrs_app/screens/Navigation_bar.dart';
import 'package:rhrs_app/screens/configuration_screen.dart';
import 'package:rhrs_app/screens/edit_profile_screen.dart';
import 'package:rhrs_app/screens/facilities_list.dart';
import 'package:rhrs_app/screens/facility_details_screen.dart';
import 'package:rhrs_app/screens/home_screen.dart';
import 'package:rhrs_app/screens/introcution_screen.dart';
import 'package:rhrs_app/screens/profile_screen.dart';
import 'package:rhrs_app/screens/search_screen.dart';
import 'package:rhrs_app/screens/test_details_screen.dart';
import 'package:rhrs_app/translations/codegen_loader.g.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/auth_screen.dart';
import 'constants.dart';
import 'models/chats_model.dart';
import 'models/review.dart';
import 'theme_cusomized.dart';
import 'package:provider/provider.dart';
import 'providers/Reviews.dart';
import 'screens/notification_list.dart';
import 'providers/notifications.dart';
import 'dart:ui';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  runApp(EasyLocalization(
      path: 'assets/translations/',
      supportedLocales: const [
        Locale("en"),
        Locale("ar"),
      ],
      fallbackLocale: Locale("en"),
      assetLoader: const CodegenLoader(),
      child: MyApp(showHome: showHome)));
}

class MyApp extends StatelessWidget {
  final bool showHome;

  const MyApp({@required this.showHome});

  @override
  Widget build(BuildContext context) {
    Locale myLocale = window.locale;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Facilities()),
        ChangeNotifierProvider(create: (_) => Facility()),
        ChangeNotifierProvider(create: (_) => ReviewModel()),
        ChangeNotifierProvider(create: (_) => Reviews()),
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => Profile()),
        ChangeNotifierProvider(create: (_) => Bookings()),
        ChangeNotifierProvider(create: (_) => Notifications()),
        ChangeNotifierProvider(create: (_) => PusherController()),
        ChangeNotifierProxyProvider<Auth, AllChat>(
          create: (_) => AllChat([], ' '),
          update: (BuildContext context, auth, AllChat previous) => AllChat(
            previous.allChats == null ? [] : previous.allChats,
            auth.token ?? " ",
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: myLocale.languageCode == "en" ? 'Raleway' : 'Cocon',
            primaryColor: kPrimaryColor,
            backgroundColor: kBackgroundLightColor,
            scaffoldBackgroundColor: kBackgroundColor,
            textTheme: TextTheme(
              headline1: TextStyle(
                  color: kPrimaryDarkenColor,
                  fontSize: 40,
                  fontFamily:
                      myLocale.languageCode == "en" ? 'Raleway' : 'Cocon',
                  fontWeight: FontWeight.w500),
              headline2: TextStyle(
                  color: kPrimaryDarkenColor,
                  fontSize: 32,
                  fontFamily:
                      myLocale.languageCode == "en" ? 'Raleway' : 'Cocon',
                  fontWeight: FontWeight.w500),
              headline3: TextStyle(
                  color: kPrimaryDarkenColor,
                  fontSize: 28,
                  fontFamily:
                      myLocale.languageCode == "en" ? 'Raleway' : 'Cocon',
                  fontWeight: FontWeight.w500),
              headline4: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 24,
                  fontFamily:
                      myLocale.languageCode == "en" ? 'Raleway' : 'Cocon',
                  fontWeight: FontWeight.bold),
              headline5: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 20,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.bold),
              headline6: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18,
                  fontFamily:
                      myLocale.languageCode == "en" ? 'Raleway' : 'Cocon',
                  fontWeight: FontWeight.bold),
              subtitle1: TextStyle(
                  color: kPrimaryColor, fontSize: 16, fontFamily: 'Rubik'),
              subtitle2: TextStyle(
                  color: kPrimaryDarkenColor,
                  fontSize: 14,
                  fontFamily:
                      myLocale.languageCode == "en" ? 'Raleway' : 'Cocon'),
              bodyText2: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  fontFamily:
                      myLocale.languageCode == "en" ? 'Raleway' : 'Cocon'),
              bodyText1: TextStyle(
                  color: kTagRentColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  fontFamily:
                      myLocale.languageCode == "en" ? 'Raleway' : 'Cocon'),
            ),
          ),
          home: auth.isAuth
              ? NavyBar()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapShot) => AuthenticationScreen()),
          routes: {
            AuthScreen.routeName: (ctx) => AuthScreen(),
            NavyBar.routeName: (ctx) => NavyBar(),
            FacilitiesList.routeName: (ctx) => FacilitiesList(),
            DetailScreen.routeName: (ctx) => DetailScreen(),
            Auth.routeName: (ctx) => AuthScreen(),
            NewDetailsScreen.routeName: (ctx) => NewDetailsScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            EditProfile.routeName: (ctx) => EditProfile(),
            SearchScreen.routeName: (ctx) => SearchScreen(),
            NotificationsList.routeName: (ctx) => NotificationsList(),
            AuthenticationScreen.routeName: (ctx) => AuthenticationScreen(),
            ConfigurationScreen.routeName: (ctx) => ConfigurationScreen(),
          },
        ),
      ),
    );
  }
}
