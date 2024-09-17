import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_training/weather_info_screen.dart';

class GreenScreen extends StatefulWidget {
  const GreenScreen({super.key});

  @override
  State<GreenScreen> createState() => _GreenScreenState();
}

class _GreenScreenState extends State<GreenScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(
      WidgetsBinding.instance.endOfFrame.then((_) {
        navigateToWeatherScreen();
      }),
    );
  }

  Future<void> navigateToWeatherScreen() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return const WeatherInfoScreen();
        },
      ),
    );
    await navigateToWeatherScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }
}
