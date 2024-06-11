import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_project_jeongdeokho/Auth/SignUpView.dart';
import 'package:todo_project_jeongdeokho/Extension/Indicator.dart';
import 'package:todo_project_jeongdeokho/Extension/ShowAlert.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginView extends StatelessWidget {

  final VoidCallback onLogin;

  const LoginView({Key? key, required this.onLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '이메일',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: '이메일을 입력해주세요',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                Text(
                  '비밀번호', // Added
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true, // Hides the entered text
              decoration: InputDecoration(
                hintText: '비밀번호를 입력해주세요', // Added
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                    context.showAlertDialog(
                      title: '경고',
                      message: '이메일과 비밀번호를 제대로 입력해주세요.',
                      buttonText: '확인',
                    );
                  } else {
                    context.startIndicator();
                    try {
                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text
                      );
                      context.stopIndicator();
                      if (credential.user != null) {
                        onLogin();
                      }
                    }  catch (e) {
                      context.stopIndicator();
                      context.showAlertDialog(title: e.toString(),
                          message: "",
                          buttonText: "확인");
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  '로그인',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpView()),
                );
              },
              child: Text(
                '회원가입 하러가기',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}