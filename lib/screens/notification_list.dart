import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notifications.dart';
import '../widgets/notification_widget.dart';
import 'package:rhrs_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationsList extends StatelessWidget {
  static const routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.notificationList.tr()),
      ),
      body: FutureBuilder(
        future: Provider.of<Notifications>(context, listen: false)
            .fetchNotifications(),
        builder: ((ctx, resultSnapShot) => resultSnapShot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<Notifications>(
                builder: (ctx, fetchedNotifications, child) => ListView.builder(
                  itemBuilder: (context, index) {
                    return NotificationWidget(
                        fetchedNotifications.notifications[index]);
                  },
                  itemCount: fetchedNotifications.notifications.length,
                ),
              )),
      ),
    );
  }
}
