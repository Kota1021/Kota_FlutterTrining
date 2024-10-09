import 'dart:convert';

import 'package:flutter/foundation.dart';
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

  Future<WeatherResponse> fetch() async {
    final requestJSON = WeatherRequest(
      area: 'tokyo',
      date: DateTime.now(),
    ).toJson();

    final response = await compute(
      _yumemiWeather.syncFetchWeather,
      jsonEncode(requestJSON),
    );
    final weatherResponse = WeatherResponse.fromJson(
      jsonDecode(response) as Map<String, dynamic>,
    );
    return weatherResponse;
  }
}

@riverpod
YumemiWeather yumemiWeatherClient(YumemiWeatherClientRef ref) {
  return YumemiWeather();
}
