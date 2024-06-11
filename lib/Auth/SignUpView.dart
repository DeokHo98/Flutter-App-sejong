import 'package:flutter/material.dart';
import 'package:todo_project_jeongdeokho/Extension/Indicator.dart';
import 'package:todo_project_jeongdeokho/Extension/ShowAlert.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 좌측 정렬
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                '이메일',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: '이메일을 입력해주세요',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                '비밀번호',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '비밀번호를 입력해주세요',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // 회원가입 버튼 클릭 시 동작하는 코드 추가
                  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                    context.showAlertDialog(
                      title: '경고',
                      message: '이메일을 입력해주세요.',
                      buttonText: '확인',
                    );
                  } else {
                    context.startIndicator();
                    try {
                      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      context.stopIndicator();
                      context.showAlertDialog(
                          title: "정상 처리 되었습니다.",
                          message: "",
                          buttonText: "확인", 
                      onPressed: () {
                        Navigator.of(context).pop();
                      });
                    } catch (e) {
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
                  '회원가입 하기',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}