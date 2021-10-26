import 'package:app_tcc_unip/connection/websocket/websocketController.dart';
import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:app_tcc_unip/ui/main/contact-list/contact-list.dart';
import 'package:app_tcc_unip/ui/main/contact-recommendation/viewContactRecommendation.dart';
import 'package:app_tcc_unip/ui/main/notification/notification-list.dart';
import 'package:app_tcc_unip/ui/main/profile/profile.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _webSocketController = WebsocketController.getInstance();
  final List<ContactRecommendation> notificationList = [];

  _MainScreenState() {
    _webSocketController.active();
    _webSocketController.addRequestAddContactListener(getNotification);
  }

  @override
  void dispose() {
    super.dispose();
    _webSocketController.removeRequestAddContactListener(getNotification);
  }

  getNotification(ContactRecommendation contactRecommendation) {
    print('$contactRecommendation');
    setState(() {
      var indexOf = notificationList.indexOf(contactRecommendation);
      if (indexOf > 0) {
        notificationList[indexOf] = contactRecommendation;
      } else {
        notificationList.add(contactRecommendation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mewple'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.more_vert),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.chat),
              ),
              Tab(
                icon: Icon(Icons.person),
              ),
              Tab(
                icon: Icon(Icons.favorite),
              ),
              Tab(
                child: Badge(
                  badgeContent: Text('${notificationList.length}'),
                  showBadge: notificationList.length > 0,
                  badgeColor: Colors.red,
                  child: Icon(Icons.notifications),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ContactList(),
            Profile(),
            ViewContactRecommendation(),
            NotificationList(
              contactList: notificationList,
              onActionItem: (contact) {
                setState(() {
                  notificationList.remove(contact);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
