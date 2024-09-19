import 'dart:convert';

import 'package:flutter_training/models/weather_request.dart';
import 'package:flutter_training/models/weather_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

part 'weather_response_repository.g.dart';

@riverpod
WeatherResponseRepository weatherResponseRepository(
  WeatherResponseRepositoryRef ref,
) {
  return WeatherResponseRepository(
    yumemiweather: ref.watch(yumemiWeatherClientProvider),
  );
}

class WeatherResponseRepository {
  WeatherResponseRepository({required YumemiWeather yumemiweather})
      : _yumemiWeather = yumemiweather;
  final YumemiWeather _yumemiWeather;

  void fetch({
    required void Function(WeatherResponse response) onSuccess,
    required void Function(String error) onError,
  }) {
    try {
      final requestJSON = WeatherRequest(
        area: 'tokyo',
        date: DateTime.now(),
      ).toJson();

      final response = _yumemiWeather.fetchWeather(jsonEncode(requestJSON));
      final weatherResponse = WeatherResponse.fromJson(
        jsonDecode(response) as Map<String, dynamic>,
      );
      onSuccess(
        weatherResponse,
      );
    } on YumemiWeatherError catch (e) {
      onError(e.toString());
    } on FormatException catch (e) {
      onError(e.toString());
    }
  }
}

@riverpod
YumemiWeather yumemiWeatherClient(YumemiWeatherClientRef ref) {
  return YumemiWeather();
}
