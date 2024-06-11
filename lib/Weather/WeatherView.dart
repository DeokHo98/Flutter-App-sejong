import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_project_jeongdeokho/Extension/Indicator.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({Key? key}) : super(key: key);

  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  TextEditingController _searchController = TextEditingController();
  String _weatherData = '';
  String _weatherIcon = '';

  Future<void> _fetchWeather(String city) async {
    final apiKey = 'b90603b1e15d914f4f7af9ec5c8df8dc';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    context.startIndicator();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _weatherData = '온도: ${data['main']['temp']}°C\n'
            '날씨 상황: ${data['weather'][0]['description']}';
        _weatherIcon = _getWeatherIcon(data['weather'][0]['main']);
      });
    } else {
      setState(() {
        _weatherData = '날씨 정보를 가져오는데 실패했습니다. 도시이름을 제대로 입력했는지 확인해주세요.';
        _weatherIcon = '❌';
      });
    }
    context.stopIndicator();
  }

  String _getWeatherIcon(String weatherType) {
    switch (weatherType) {
      case 'Clear':
        return '☀️';
      case 'Clouds':
        return '☁️';
      case 'Rain':
        return '🌧️';
      case 'Snow':
        return '❄️';
      case 'Thunderstorm':
        return '⛈️';
      case 'Drizzle':
        return '🌦️';
      case 'Mist':
        return '🌫️';
      case 'Smoke':
        return '🌫️';
      case 'Haze':
        return '🌫️';
      case 'Dust':
        return '🌫️';
      case 'Fog':
        return '🌫️';
      case 'Sand':
        return '🌫️';
      case 'Ash':
        return '🌫️';
      case 'Squall':
        return '🌬️';
      case 'Tornado':
        return '🌪️';
      default:
        return '󠀠󠀠󠀠󠀠🌐';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: null,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '날씨를 알아볼 도시명을 입력해주세요.',
                  prefixIcon: Icon(Icons.location_city),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _weatherData = '';
                        _weatherIcon = '';
                      });
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  _fetchWeather(value);
                },
              ),
              SizedBox(height: 20),
              if (_weatherIcon.isNotEmpty)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _weatherIcon,
                      style: TextStyle(fontSize: 200),
                    ),
                  ),
                ),
              if (_weatherData.isNotEmpty)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    _weatherData,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
