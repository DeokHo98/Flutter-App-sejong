import 'package:flutter/material.dart';
import 'package:todo_project_jeongdeokho/Auth/loginView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_project_jeongdeokho/TabBar/MainTabBar.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAuth.instance
      .authStateChanges()
      .listen((User? user) {
    runApp(TodoApp(isLoggedIn: user != null));
  });
}

class TodoApp extends StatefulWidget {
  final bool isLoggedIn;

  const TodoApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  TodoAppState createState() => TodoAppState(isLoggedIn: isLoggedIn);
}

class TodoAppState extends State<TodoApp> {
  bool isLoggedIn;

  TodoAppState({required this.isLoggedIn}) : super();

  @override
  void initState() {
    super.initState();
    isLoggedIn = widget.isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deokho_Todo_App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? MainTabBarView(onLogout: () {
        setState(() {
          isLoggedIn = false;
        });
      }) : LoginView(onLogin: () {
        setState(() {
          isLoggedIn = true;
        });
      }),
    );
  }
}