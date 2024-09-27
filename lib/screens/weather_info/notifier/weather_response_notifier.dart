import 'package:flutter_training/models/weather_response.dart';
import 'package:flutter_training/repositories/weather_response_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

part 'weather_response_notifier.g.dart';

@riverpod
class WeatherResponseNotifier extends _$WeatherResponseNotifier {
  @override
  WeatherResponse? build() => null;
  void fetch({
    required void Function(String error) onError,
  }) {
    try {
      state = ref.watch(weatherResponseRepositoryProvider).fetch();
    } on YumemiWeatherError catch (e) {
      onError(e.toString());
    } on FormatException catch (e) {
      onError(e.toString());
    } on CheckedFromJsonException catch (e) {
      onError(e.toString());
    }
  }
}
