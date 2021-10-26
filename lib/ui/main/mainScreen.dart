import 'package:app_tcc_unip/connection/websocket/websocketController.dart';
import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:app_tcc_unip/service/authService.dart';
import 'package:app_tcc_unip/service/tokenService.dart';
import 'package:app_tcc_unip/ui/login/loginScreen.dart';
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
            new PopupMenuButton<int>(
              itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                new PopupMenuItem<int>(
                  value: 1,
                  child: new Text('Sair'),
                ),
              ],
              onSelected: (int value) async {
                await TokenService().removeToken();
                await AuthService().disableAutoLogin();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) {
                      return Login();
                    },
                  ),
                );
              },
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
