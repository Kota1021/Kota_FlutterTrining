import 'package:flutter_training/models/weather_response.dart';
import 'package:flutter_training/repositories/weather_response_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weather_response_notifier.g.dart';

@riverpod
class WeatherResponseNotifier extends _$WeatherResponseNotifier {
  @override
  WeatherResponse? build() => null;
  void fetch() {
    state = ref.read(weatherResponseRepositoryProvider).fetch();
  }
}
