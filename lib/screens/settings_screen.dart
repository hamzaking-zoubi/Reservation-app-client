import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:rhrs_app/models/auth.dart';
import 'package:rhrs_app/models/profile.dart';
import 'package:rhrs_app/screens/configuration_screen.dart';
import 'package:rhrs_app/screens/profile_screen.dart';
import 'package:rhrs_app/widgets/settings_list_item.dart';
import 'package:provider/provider.dart';
import 'notification_list.dart';
import '../constants.dart';
import 'package:rhrs_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

final kTitleTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.7),
  fontWeight: FontWeight.w600,
);

class SettingsScreen extends StatelessWidget {
  static const routeName = '/ProfileScreen';

  void _showErrorDialog(String error, context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(LocaleKeys.logOut.tr()),
              content: Text(error),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('NO')),
                FlatButton(
                    onPressed: () => Provider.of<Auth>(context, listen: false)
                        .logout(context),
                    child: Text('Yes'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    Profile profile = Provider.of<Profile>(context);
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);

    var profileInfo = Column(
      children: <Widget>[
        Container(
          height: kSpacingUnit.w * 10,
          width: kSpacingUnit.w * 10,
          margin: EdgeInsets.only(top: kSpacingUnit.w * 2),
          child: Stack(
            children: <Widget>[
              CircleAvatar(
                radius: kSpacingUnit.w * 5,
                backgroundImage: profile.profilePhoto != null
                    ? NetworkImage(onlineApi + profile.profilePhoto)
                    : AssetImage('assets/images/bp_avatar.png'),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: kSpacingUnit.w * 2.5,
                  width: kSpacingUnit.w * 2.5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    heightFactor: kSpacingUnit.w * 1.5,
                    widthFactor: kSpacingUnit.w * 1.5,
                    child: Icon(
                      LineAwesomeIcons.pen,
                      color: kPrimaryColor,
                      size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: kSpacingUnit.w * 2),
        Text(
          '${profile.userName}',
          style: kTitleTextStyle,
        ),
        SizedBox(height: kSpacingUnit.w * 0.5),
        Text(
          '${profile.email}',
          style: kTitleTextStyle,
        ),
        SizedBox(height: kSpacingUnit.w * 3),
      ],
    );

    /*var themeSwitcher = ThemeSwitcher(
      builder: (context) {
        return AnimatedCrossFade(
          duration: Duration(milliseconds: 200),
          crossFadeState:
          ThemeProvider.of(context).brightness == Brightness.dark
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: GestureDetector(
            onTap: () =>
                ThemeSwitcher.of(context).changeTheme(theme: kLightTheme),
            child: Icon(
              LineAwesomeIcons.sun,
              size: ScreenUtil().setSp(kSpacingUnit.w * 3),
            ),
          ),
          secondChild: GestureDetector(
            onTap: () =>
                ThemeSwitcher.of(context).changeTheme(theme: kDarkTheme),
            child: Icon(
              LineAwesomeIcons.moon,
              size: ScreenUtil().setSp(kSpacingUnit.w * 3),
            ),
          ),
        );
      },
    );*/

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: kSpacingUnit.w * 3),
        Icon(
          LineAwesomeIcons.arrow_left,
          size: ScreenUtil().setSp(kSpacingUnit.w * 3),
        ),
        profileInfo,
        //themeSwitcher,
        SizedBox(width: kSpacingUnit.w * 3),
      ],
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: <Widget>[
                SettingsListItem(
                  icon: LineAwesomeIcons.user,
                  text: LocaleKeys.profile.tr(),
                  onPress: (){
                    Navigator.pushNamed(context, ProfileScreen.routeName);
                  },
                ),
                SettingsListItem(
                  icon: Icons.notifications_none,
                  text: LocaleKeys.notifications.tr(),
                  onPress: (){
                    Navigator.pushNamed(context, NotificationsList.routeName);
                  },
                ),
                SettingsListItem(
                  icon: LineAwesomeIcons.question_circle,
                  text: LocaleKeys.help.tr(),
                  /*onPress: (){
                    Navigator.pushNamed(context, AuthenticationScreen.routeName);
                  },*/
                ),
                SettingsListItem(
                  icon: LineAwesomeIcons.cog,
                  text: LocaleKeys.settingsScreen.tr(),
                  onPress: (){
                    Navigator.pushNamed(context, ConfigurationScreen.routeName);
                  },
                ),
                /*SettingsListItem(
                  icon: LineAwesomeIcons.user_plus,
                  text: 'Invite a Friend',
                ),*/
                SettingsListItem(
                  icon: LineAwesomeIcons.alternate_sign_out,
                  text: LocaleKeys.logOut.tr(),
                  hasNavigation: false,
                  onPress: () {
                    _showErrorDialog(LocaleKeys.youSure.tr(), context);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
