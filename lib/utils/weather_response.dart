import 'package:flutter_training/utils/extensions/enum.dart';
import 'package:flutter_training/weather_kind.dart';

class WeatherResponse {
  WeatherResponse({
    required this.weatherCondition,
    required this.maxTemperature,
    required this.minTemperature,
    required this.date,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    final weatherCondition =
        WeatherKind.values.byNameOrNull(json['weather_condition'].toString());

    if (weatherCondition == null) {
      throw const FormatException('invalid weatherCondition');
    }

    final maxTemperature = int.parse(json['max_temperature'].toString());
    final minTemperature = int.parse(json['min_temperature'].toString());
    final date = DateTime.parse(json['date'].toString());
    return WeatherResponse(
      weatherCondition: weatherCondition,
      maxTemperature: maxTemperature,
      minTemperature: minTemperature,
      date: date,
    );
  }

  final WeatherKind weatherCondition;
  final int maxTemperature; // degree in Celsius
  final int minTemperature; // degree in Celsius
  final DateTime date;
}
