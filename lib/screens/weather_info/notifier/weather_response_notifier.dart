import 'dart:async';

import 'package:flutter_training/models/weather_response.dart';
import 'package:flutter_training/repositories/weather_response_repository.dart';
import 'package:flutter_training/screens/weather_info/notifier/loading_state_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weather_response_notifier.g.dart';

@riverpod
class WeatherResponseNotifier extends _$WeatherResponseNotifier {
  @override
  WeatherResponse? build() => null;
  Future<void> fetch() async {
    ref.read(loadingStateNotifierProvider.notifier).startLoading();
    state = await ref.read(weatherResponseRepositoryProvider).fetch();
    ref.read(loadingStateNotifierProvider.notifier).stopLoading();
  }
}
