import 'package:flutter/material.dart';
import '../models/notification.dart';

class NotificationWidget extends StatelessWidget {
  final Notification1 notification1;
  NotificationWidget(this.notification1);

  String getImage(){
    if(notification1.notifyType == 'UnBooking'){
      return 'assets/images/Delete.png';
    }
    else if(notification1.notifyType == 'Delete facility'){
      return 'assets/images/Cancel.png';
    }
    else if(notification1.notifyType == 'Booking'){
      return 'assets/images/Done.png';
    }
    else{
      return 'assets/images/Done.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(notification1.title),
        subtitle: Text(notification1.content,style: TextStyle(fontSize: 11),),
        leading: Image.asset(getImage()),

      ),
    );
  }
}
