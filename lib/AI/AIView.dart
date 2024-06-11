import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIView extends StatefulWidget {
  const AIView({Key? key}) : super(key: key);

  @override
  _AIViewState createState() => _AIViewState();
}

class _AIViewState extends State<AIView> {
  String _generatedImageStatus = 'AI 이미지 생성 대기중';
  String _imageUrl = '';
  TextEditingController _textEditingController = TextEditingController();
  bool _loading = false;

  Future<void> generateImage() async {
    setState(() {
      _loading = true;
    });

    String prompt = _textEditingController.text;

    // REST API 호출
    final String REST_API_KEY = 'f3ff77690f2a34e751b9de414d0f0542';
    final String url = 'https://api.kakaobrain.com/v2/inference/karlo/t2i';
    final Map<String, String> headers = {
      'Authorization': 'KakaoAK $REST_API_KEY',
      'Content-Type': 'application/json'
    };
    final Map<String, dynamic> body = {
      "version": "v2.1",
      "prompt": prompt,
      "negative_prompt": "",
      "height": 1024,
      "width": 1024
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

    setState(() {
      _loading = false;
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> images = data['images'];
      if (images.isNotEmpty) {
        setState(() {
          _imageUrl = images[0]['image'];
          _generatedImageStatus = 'AI 이미지 생성 완료';
        });
      } else {
        setState(() {
          _imageUrl = '';
          _generatedImageStatus = '이미지를 찾을 수 없습니다.';
        });
      }
    } else {
      setState(() {
        _imageUrl = '';
        _generatedImageStatus = 'API 호출 실패';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: null,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_loading)
                    CircularProgressIndicator(),
                  if (!_loading && _imageUrl.isEmpty)
                    Text(
                      _generatedImageStatus,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  if (!_loading && _imageUrl.isNotEmpty)
                    Image.network(
                      _imageUrl,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(),
                          hintText: '이미지를 생성할 단어를 조합해주세요.',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: generateImage,
                    child: Text('생성'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



