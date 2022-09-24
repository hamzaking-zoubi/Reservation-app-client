import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhrs_app/models/profile.dart';
import '../widgets/profile_item_card.dart';
import '../widgets/profile_stack_container.dart';
import 'package:rhrs_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/ProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<Profile>(context).fetchProfileInfo(),
        builder: ((ctx, resultSnapShot) => resultSnapShot.connectionState ==
                ConnectionState.waiting
            ? Padding(
                padding: const EdgeInsets.all(14.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : Consumer<Profile>(
                builder: (ctx, prof, child) => SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      StackContainer(
                        userName: prof.myProfile.userName ?? 'anas',
                        userImage: prof.myProfile.profilePhoto ?? '',
                      ),
                      ListView(
                        children: [
                          CardItem(
                              icon: Icons.email,
                              fieldName: LocaleKeys.email.tr(),
                              fieldValue:
                                  prof.myProfile.email ?? 'qwer@gmail.com'),
                          CardItem(
                              icon: Icons.person,
                              fieldName: LocaleKeys.name.tr(),
                              fieldValue: prof.myProfile.userName ?? 'anas'),
                          CardItem(
                            icon: Icons.phone,
                            fieldName: LocaleKeys.phone.tr(),
                            fieldValue: '+963937925594',
                          ),
                          CardItem(
                            icon: Icons.person_outline,
                            fieldName: LocaleKeys.gender.tr(),
                            fieldValue: prof.myProfile.gender ?? 'male',
                          ),
                          CardItem(
                            icon: Icons.hourglass_bottom,
                            fieldName: LocaleKeys.age.tr(),
                            fieldValue: prof.myProfile.age ?? '21',
                          ),
                        ],
                        //CardItem(),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      )
                    ],
                  ),
                ),
              )),
      ),
    );
  }
}
