import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_training/components/weather_condition_panel.dart';
import 'package:flutter_training/screens/weather_info/notifier/weather_response_notifier.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

class WeatherInfoScreen extends ConsumerWidget {
  const WeatherInfoScreen({super.key});

  Future<void> _showErrorDialog(BuildContext context, String message) async {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final labelLargeStyle = Theme.of(context).textTheme.labelLarge;
    final weatherProvider = ref.watch(weatherResponseNotifierProvider);

    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Column(
            children: [
              const Spacer(),
              WeatherConditionPanel(
                weatherResponse: weatherProvider,
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
                            key: const Key('closeButton'),
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
                            key: const Key('reloadButton'),
                            onPressed: () {
                              try {
                                ref
                                    .read(
                                      weatherResponseNotifierProvider.notifier,
                                    )
                                    .fetch();
                              } on YumemiWeatherError catch (e) {
                                unawaited(
                                  _showErrorDialog(
                                    context,
                                    e.toString(),
                                  ),
                                );
                              } on FormatException catch (e) {
                                unawaited(
                                  _showErrorDialog(
                                    context,
                                    e.toString(),
                                  ),
                                );
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
