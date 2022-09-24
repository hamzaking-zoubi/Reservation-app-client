import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:rhrs_app/screens/bookings_screen.dart';
import 'package:rhrs_app/screens/chats_screen.dart';
import 'package:rhrs_app/screens/favorites_screen.dart';
import 'package:rhrs_app/screens/settings_screen.dart';
import 'home_screen.dart';
import 'package:rhrs_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class NavyBar extends StatefulWidget {
  static const routeName = '/NavyBar';

  @override
  _NavyBarState createState() => _NavyBarState();
}

class _NavyBarState extends State<NavyBar> {
  List _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      {'page': HomeScreen()/*SearchScreen()*/, 'title': LocaleKeys.homeScreen.tr()},
      {'page': FavoritesScreen(), 'title': LocaleKeys.favoritesScreen.tr()},
      {'page' : BookingsScreen(),'title': LocaleKeys.bookingsScreen.tr()},
      {'page': ChatScreen(), 'title': LocaleKeys.chatsScreen.tr()},
      {'page': SettingsScreen(), 'title': LocaleKeys.settingsScreen.tr()},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
        elevation: 0.0,
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedPageIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() => _selectedPageIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text(
              LocaleKeys.homeScreen.tr(),
              style: Theme.of(context).textTheme.headline6,
            ),
            activeColor: Theme.of(context).primaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.favorite),
            title:
                Text(LocaleKeys.favoritesScreen.tr(), style: Theme.of(context).textTheme.headline6),
            activeColor: Theme.of(context).primaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.save),
            title: Text(LocaleKeys.bookingsScreen.tr(), style: Theme.of(context).textTheme.headline6),
            activeColor: Theme.of(context).primaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.chat),
            title: Text(LocaleKeys.chatsScreen.tr(), style: Theme.of(context).textTheme.headline6),
            activeColor: Theme.of(context).primaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title:
                Text(LocaleKeys.settingsScreen.tr(), style: Theme.of(context).textTheme.headline6),
            activeColor: Theme.of(context).primaryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
