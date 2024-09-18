import 'package:flutter/material.dart';
import 'package:flutter_training/utils/weather_response.dart';
import 'package:flutter_training/weather_kind.dart';

class WeatherConditionPanel extends StatelessWidget {
  const WeatherConditionPanel({
    required WeatherResponse? weatherResponse,
    required TextStyle? labelLargeStyle,
    super.key,
  })  : _labelLargeStyle = labelLargeStyle,
        _weatherResponse = weatherResponse;

  final WeatherResponse? _weatherResponse;
  final TextStyle? _labelLargeStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: _weatherResponse?.weatherCondition.svgImage ??
              const Placeholder(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${_weatherResponse?.minTemperature.toString() ?? '** '} ℃',
                  textAlign: TextAlign.center,
                  style: _labelLargeStyle?.copyWith(color: Colors.blue),
                ),
              ),
              Expanded(
                child: Text(
                  '${_weatherResponse?.maxTemperature.toString() ?? '** '} ℃',
                  textAlign: TextAlign.center,
                  style: _labelLargeStyle?.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
