import 'dart:convert';

import 'package:flutter_training/models/weather_request.dart';
import 'package:flutter_training/models/weather_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

part 'providers.g.dart';

@riverpod
class WeatherResponseNotifier extends _$WeatherResponseNotifier {
  @override
  WeatherResponse? build() => null;

  final _yumemiWeather = YumemiWeather();

  // may throw FormatException or YumemiWeatherError
  void fetch() {
    final requestJSON = WeatherRequest(
      area: 'tokyo',
      date: DateTime.now(),
    ).toJson();

    final response = _yumemiWeather.fetchWeather(jsonEncode(requestJSON));

    state = WeatherResponse.fromJson(
      jsonDecode(response) as Map<String, dynamic>,
    );
  }
}
