import 'package:flutter/material.dart';

class ConfigurationScreen extends StatelessWidget {
  static const routeName = '/ConfigurationScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Configuration'),
      ),
      /*body: SwitchListTile(
        onChanged: (value)async{
          /*if(value == true) {
            await context.setLocale()
          }
          else{

          }*/
        },
      ),*/
    );
  }
}
