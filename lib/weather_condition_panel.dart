import 'package:flutter/material.dart';
import 'package:flutter_training/weather_kind.dart';

class WeatherConditionPanel extends StatelessWidget {
  const WeatherConditionPanel({
    required WeatherKind? weatherKind,
    required TextStyle? labelLargeStyle,
    super.key,
  })  : _labelLargeStyle = labelLargeStyle,
        _weatherKind = weatherKind;

  final WeatherKind? _weatherKind;
  final TextStyle? _labelLargeStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: _weatherKind?.svgImage ?? const Placeholder(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '** ℃',
                  textAlign: TextAlign.center,
                  style: _labelLargeStyle?.copyWith(color: Colors.blue),
                ),
              ),
              Expanded(
                child: Text(
                  '** ℃',
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
