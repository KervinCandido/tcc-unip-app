import 'package:app_tcc_unip/ui/main/contact-list/contact-list.dart';
import 'package:app_tcc_unip/ui/main/profile/profile.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Instant Crush'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.person),
              ),
              Tab(
                icon: Icon(Icons.chat),
              ),
              Tab(
                icon: Icon(Icons.favorite),
              ),
              Tab(
                icon: Icon(Icons.menu),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Profile(),
            ContactList(),
            Icon(Icons.directions_bike),
            Icon(Icons.directions_boat),
          ],
        ),
      ),
    );
  }
}
