import 'package:flutter/material.dart';
import '../appData/AuthData.dart';
import '../appData/ThemeStyle.dart';

class Notification1 extends StatefulWidget {
  final String title;
  final String content;
  final double screenWidth;

  const Notification1({Key? key, required this.title, required this.content, required this.screenWidth}) : super(key: key);

  @override
  _Notification1State createState() => _Notification1State();
}

class _Notification1State extends State<Notification1> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  List<Map<String, dynamic>> notification = [];
  bool isLoading = true;
  bool showDot = false;
  int dot=0;

  Future<void> reloadnotification() async {
    try {
       List<Map<String, dynamic>> notifications = await AuthData.fetchNotifications();
      setState(() {
        AuthData.unreadCount = notifications.where((notif) => !notif['is_read']).length;
        showDot = AuthData.unreadCount > 0;
      });
    } catch (error) {
      print('Error fetching notifications: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
    NotificationData();
  }

  void dismiss() {
    _animationController.reverse().then((_) {
      Navigator.of(context).pop();
    });
  }

  Future<void> NotificationData() async {
    try {
      final List<Map<String, dynamic>> data = await AuthData.fetchNotifications();
      setState(() {
        notification = data;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching notification data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onTap: () {
          dismiss();
        },
        child: Container(
          color: Colors.transparent,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.titleMedium!,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.9,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                                // reloadnotification();
                              },
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 88.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Notification',
                                  style: ThemeTextStyle.generalSubHeading.copyWith(fontSize: 25,color: const Color(0xFFEE6724)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: isLoading
                            ? const CircularProgressIndicator(color:GeneralThemeStyle.button)
                            : notification.isEmpty
                            ? const Center(
                          child: Text(
                            'No notifications available',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                            : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: notification.length * 2 - 1,
                          itemBuilder: (context, index) {
                            if (index.isOdd) {
                              return const Divider(color: Colors.grey);
                            }
                            final int notificationIndex = index ~/ 2;
                            final Map<String, dynamic> notif = notification[notificationIndex];
                            final bool isUnread = notif.containsKey('is_read') && !notif['is_read'];
                            final DateTime dateTime = DateTime.parse(notif['timestamp']);
                            final String timeString = '${dateTime.hour}:${dateTime.minute}';
                            final String dateString = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                            return ListTile(
                              title: Text(
                                notif['type'],
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.deepOrange),
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notif['message'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,color: Colors.black),
                                    ),
                                  ),
                                  if (isUnread)
                                    Icon(Icons.circle, color: Colors.orange, size: 8),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  notif['is_read'] = true;
                                  showDot = false;

                                });

                                _showMessageDialog(
                                  context,
                                  notif['type'],
                                  notif['message'],
                                  '$dateString $timeString',
                                  notif['id'],
                                      (bool value) {
                                    setState(() {
                                      showDot = value;
                                    });
                                  },
                                );

                                _markAsRead(notif['id']);
                              },
                            );
                          },
                        ),
                      ),
                      if(showDot)
                        Icon(Icons.circle, color: Colors.orange, size: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMessageDialog(BuildContext context, String title, String message, String dateTime, String id, Function(bool) updateDot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              SizedBox(height: 10),
              Text('Date & Time: $dateTime', style: const TextStyle(fontSize: 12)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                updateDot(false);
                Navigator.pop(context);
                _markAsRead(id);
                AuthData.unreadCount++;
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.deepOrange),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> _markAsRead(String id) async {
    try {
      final result = await AuthData.Markread(id);
      if (result is Map<String, dynamic>) {
        setState(() {
          notification = notification.map((notif) {
            if (notif['id'] == id) {
              notif['is_read'] = true;

            }
            return notif;
          }).toList();
        });
      } else {
        print('Unexpected result type from AuthData.Markread(id)');
      }
    } catch (error) {
      print('Error marking notification as read: $error');
    }
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
