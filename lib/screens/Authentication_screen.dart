import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhrs_app/models/auth.dart';
import 'package:rhrs_app/translations/locale_keys.g.dart';
import 'package:rhrs_app/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'Navigation_bar.dart';

class AuthenticationScreen extends StatefulWidget {
  static const routeName = '/authentication';

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final GlobalKey<FormState> _signInformKey = GlobalKey();
  final GlobalKey<FormState> _signUpformKey = GlobalKey();

  String name = '';
  String email = '';
  String password = '';
  String cPassword = '';

  final outlineBorder =
      OutlineInputBorder(borderRadius: BorderRadius.circular(10));

  final _passwordController = TextEditingController();
  final _uPasswordController = TextEditingController();

  void _showErrorDialog(String error) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(LocaleKeys.error.tr()),
              content: Text(error),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(LocaleKeys.ok.tr()))
              ],
            ));
  }

  Future<void> _submitSignIn() async {
    if (!_signInformKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _signInformKey.currentState.save();
    try {
      // Log user in
      await Provider.of<Auth>(context, listen: false)
          .signIn(email, password)
          .then((_) {
        Navigator.of(context).pushReplacementNamed(NavyBar.routeName);
      });
    } catch (error) {
      _showErrorDialog(error.toString());
    }
  }

  Future<void> _submitSignUp() async {
    if (!_signUpformKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _signUpformKey.currentState.save();
    try {
      // Log user in
      await Provider.of<Auth>(context, listen: false)
          .signUp(email, password, cPassword, name)
          .then((_) {
        Navigator.of(context).pushReplacementNamed(NavyBar.routeName);
      });
    } catch (error) {
      _showErrorDialog(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Image.asset(
              'assets/images/bp_header_login.png',
              width: double.infinity,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: DefaultTabController(
                length: 2,
                child: Column(children: [
                  TabBar(
                    indicatorColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Color(0xFF555555),
                    labelColor: Theme.of(context).primaryColor,
                    labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    tabs: [
                      Tab(
                        text: LocaleKeys.signIn.tr(),
                      ),
                      Tab(
                        text: LocaleKeys.signUp.tr(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: 400.0,
                      child: TabBarView(children: [
                        Column(
                          children: [
                            Text(
                              LocaleKeys.bookifyLogin.tr(),
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Form(
                              key: _signInformKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    autofocus: true,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.email),
                                        labelText: LocaleKeys.email.tr()),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value.isEmpty ||
                                          !value.contains('@')) {
                                        return LocaleKeys.invalidEmail.tr();
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      email = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    autofocus: true,
                                    //textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.vpn_key_outlined),
                                        labelText: LocaleKeys.password.tr()),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value.isEmpty || value.length < 5) {
                                        return LocaleKeys.shortPassword.tr();
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      password = value;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            CustomButton(
                                buttonLabel: LocaleKeys.signIn.tr(),
                                onPress: () async {
                                  await _submitSignIn();
                                })
                          ],
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                LocaleKeys.bookifySignUp.tr(),
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Form(
                                  key: _signUpformKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        autofocus: true,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            icon: Icon(Icons.person),
                                            labelText: LocaleKeys.name.tr()),
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return LocaleKeys.invalidName.tr();
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          name = value;
                                        },
                                      ),
                                      TextFormField(
                                        autofocus: true,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            icon: Icon(Icons.email),
                                            labelText: LocaleKeys.email.tr()),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value.isEmpty ||
                                              !value.contains('@')) {
                                            return LocaleKeys.invalidEmail.tr();
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          email = value;
                                        },
                                      ),
                                      TextFormField(
                                        autofocus: true,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            icon: Icon(Icons.vpn_key),
                                            labelText:
                                                LocaleKeys.password.tr()),
                                        controller: _uPasswordController,
                                        obscureText: true,
                                        validator: (value) {
                                          if (value.isEmpty ||
                                              value.length < 5) {
                                            return LocaleKeys.shortPassword
                                                .tr();
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          password = value;
                                        },
                                      ),
                                      TextFormField(
                                        autofocus: true,
                                        //textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            icon: Icon(Icons.vpn_key),
                                            labelText: LocaleKeys
                                                .confirmPassword
                                                .tr()),
                                        obscureText: true,
                                        validator: (value) {
                                          if (value !=
                                              _uPasswordController.value.text) {
                                            return LocaleKeys
                                                .passwordDoesNotMatch
                                                .tr();
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          cPassword = value;
                                        },
                                      ),
                                    ],
                                  )),
                              SizedBox(height: 30),
                              CustomButton(
                                  buttonLabel: LocaleKeys.signUp.tr(),
                                  onPress: () async {
                                    await _submitSignUp();
                                  })
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ]),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
