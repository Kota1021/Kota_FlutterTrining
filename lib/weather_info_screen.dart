import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_training/green_screen.dart';
import 'package:flutter_training/utils/extensions/enum.dart';
import 'package:flutter_training/weather_condition_panel.dart';
import 'package:flutter_training/weather_kind.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

class WeatherInfoScreen extends StatefulWidget {
  const WeatherInfoScreen({super.key});

  @override
  State<WeatherInfoScreen> createState() => _WeatherInfoScreenState();
}

class _WeatherInfoScreenState extends State<WeatherInfoScreen> {
  final YumemiWeather _yumemiWeather = YumemiWeather();
  WeatherKind? _weatherKind;

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
                weatherKind: _weatherKind,
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
                              unawaited(
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (context) {
                                      return const GreenScreen();
                                    },
                                  ),
                                ),
                              );
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
                              final name = _yumemiWeather.fetchSimpleWeather();
                              setState(() {
                                _weatherKind =
                                    WeatherKind.values.byNameOrNull(name);
                              });
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
