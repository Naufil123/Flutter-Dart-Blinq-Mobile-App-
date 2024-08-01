import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '../appData/AuthData.dart';
import '../appData/dailogbox.dart';
import '../home/NotificationScreen.dart';

class BellNotifAndHelp extends StatefulWidget {
  BellNotifAndHelp({required Key key}) : super(key: key);

  @override
  _BellNotifAndHelpState createState() => _BellNotifAndHelpState();
}

class _BellNotifAndHelpState extends State<BellNotifAndHelp> {
  bool notification = false;

  @override
  void initState() {
    super.initState();
    AuthData.fetchNotifications();

  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        IconButton(
          onPressed: () {
            _showDialog3(context);
          },
          icon: Image.asset(
            'assets/images/help.png',
            width: screenWidth * 0.1,
            height: screenWidth * 0.1,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              notification = !notification;
              _showDialog2(context);
            });
          },
          icon: Builder(
            builder: (context) {
              return badges.Badge(
                badgeContent: Text(AuthData.unreadCount.toString()),
                badgeColor: Colors.orange,
                position: BadgePosition.topEnd(top: -10, end: -10),
                showBadge: AuthData.unreadCount > 0,
                animationType: BadgeAnimationType.slide,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 0.5),
                  ),
                  child: Icon(Icons.notifications_none_outlined, color: Colors.orange, size: 26),
                ),
              );
            },
          ),
        ),
      ],
    );
  }


  void _showDialog3(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    FAQ.showAlertDialog(
      context,
      'Successful!',
      'Your ID has been verified \nsuccessfully!',
      screenWidth,
    );
  }

  void _showDialog2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Notification1(
          title: 'Notification Title',
          content: 'Notification Content',
          screenWidth: MediaQuery.of(context).size.width,
        );
      },
    );
  }
}
