import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_training/utils/weather_request.dart';
import 'package:flutter_training/utils/weather_response.dart';
import 'package:flutter_training/weather_condition_panel.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

class WeatherInfoScreen extends StatefulWidget {
  const WeatherInfoScreen({super.key});

  @override
  State<WeatherInfoScreen> createState() => _WeatherInfoScreenState();
}

class _WeatherInfoScreenState extends State<WeatherInfoScreen> {
  final YumemiWeather _yumemiWeather = YumemiWeather();
  WeatherResponse? _weatherResponse;

  Future<void> _showErrorDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error occurred'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelLargeStyle = Theme.of(context).textTheme.labelLarge;
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Column(
            children: [
              const Spacer(),
              WeatherConditionPanel(
                weatherResponse: _weatherResponse,
                labelLargeStyle: labelLargeStyle,
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Close',
                              textAlign: TextAlign.center,
                              style:
                                  labelLargeStyle?.copyWith(color: Colors.blue),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              try {
                                final requestJSON = WeatherRequest(
                                  area: 'tokyo',
                                  date: DateTime.now(),
                                ).toJson();
                                final response = _yumemiWeather
                                    .fetchWeather(jsonEncode(requestJSON));
                                setState(() {
                                  _weatherResponse = WeatherResponse.fromJson(
                                    jsonDecode(response)
                                        as Map<String, dynamic>,
                                  );
                                });
                              } on YumemiWeatherError catch (e) {
                                unawaited(_showErrorDialog(e.toString()));
                              } on FormatException catch (e) {
                                unawaited(_showErrorDialog(e.toString()));
                              }
                            },
                            child: Text(
                              'Reload',
                              textAlign: TextAlign.center,
                              style:
                                  labelLargeStyle?.copyWith(color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
