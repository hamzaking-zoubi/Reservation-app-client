import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rhrs_app/models/profile.dart';
import 'package:rhrs_app/widgets/custom_button.dart';
import 'package:rhrs_app/constants.dart';
import 'package:rhrs_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/edit_profile';

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final inputBorder =
      OutlineInputBorder(borderRadius: BorderRadius.circular(15));
  String email, name, phone, gender, age;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.editProfileInfo.tr()),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16,horizontal: 12),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 4,),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    decoration:
                        InputDecoration(border: inputBorder, labelText: LocaleKeys.name.tr()),
                    onSaved: (value) {
                      name = value;
                    },
                  ),
                  SIZED_BOX_H12,
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      decoration: InputDecoration(
                          border: inputBorder, labelText: LocaleKeys.email.tr()),
                      onSaved: (value) {
                        email = value;
                      }),
                  SIZED_BOX_H12,
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: inputBorder, labelText: LocaleKeys.phone.tr()),
                      onSaved: (value) {
                        phone = value;
                      }),
                  SIZED_BOX_H12,
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      decoration: InputDecoration(
                          border: inputBorder, labelText: LocaleKeys.gender.tr()),
                      onSaved: (value) {
                        gender = value;
                      }),
                  SIZED_BOX_H12,
                  TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: inputBorder, labelText: LocaleKeys.age.tr()),
                      onSaved: (value) {
                        age = value;
                      }),
                  SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    buttonLabel: LocaleKeys.submit.tr(),
                    onPress: () async{
                      _formKey.currentState.save();
                      print("name");
                      print(name);
                      print("email");
                      print(email);
                      print("phone");
                      print(phone);
                      await Provider.of<Profile>(context,listen: false).updateProfile(name, email, phone,age,gender).then((value) => Navigator.pop(context));
                    },
                  )
                ],
              ),
            )),
      ),
    );
  }
}
