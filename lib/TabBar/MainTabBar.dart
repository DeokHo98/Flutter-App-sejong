import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_project_jeongdeokho/AI/AIView.dart';
import 'package:todo_project_jeongdeokho/Extension/Indicator.dart';
import 'package:todo_project_jeongdeokho/Extension/ShowAlert.dart';
import 'package:todo_project_jeongdeokho/Todo/TodoView.dart';
import 'package:todo_project_jeongdeokho/Weather/WeatherView.dart';

class MainTabBarView extends StatefulWidget {
  final VoidCallback onLogout;

  const MainTabBarView({Key? key, required this.onLogout}) : super(key: key);

  @override
  MainTabBarViewState createState() => MainTabBarViewState(onLogout: onLogout);
}

class MainTabBarViewState extends State<MainTabBarView> {
  final VoidCallback onLogout;

  MainTabBarViewState({required this.onLogout});

  int selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TodoView(),
    WeatherView(),
    AIView()
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('로그아웃하기'),
                    onTap: () async {
                      context.startIndicator();
                      try {
                        await FirebaseAuth.instance.signOut();
                        context.stopIndicator();
                        Navigator.pop(context);
                        onLogout();
                      } catch (e) {
                        context.stopIndicator();
                        context.showAlertDialog(
                          title: e.toString(),
                          message: "",
                          buttonText: "확인",
                        );
                      }
                      onLogout();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.close),
                    title: Text('닫기'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: '할일',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sunny),
            label: '날씨',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.computer),
            label: 'AI',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: onItemTapped,
      ),
      floatingActionButton: selectedIndex != 2
          ? FloatingActionButton(
        onPressed: () {
          _showModalBottomSheet(context);
        },
        child: Icon(Icons.person),
        backgroundColor: Colors.white,
      )
          : null,
    );
  }
}
