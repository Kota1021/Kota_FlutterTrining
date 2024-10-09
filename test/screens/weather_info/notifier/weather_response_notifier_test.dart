import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_training/models/weather_kind.dart';
import 'package:flutter_training/models/weather_response.dart';
import 'package:flutter_training/repositories/weather_response_repository.dart';
import 'package:flutter_training/screens/weather_info/notifier/weather_response_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

import 'weather_response_notifier_test.mocks.dart';

@GenerateNiceMocks([MockSpec<YumemiWeather>()])
void main() {
  final mockClient = MockYumemiWeather();
  const jsonString = '''
        {
          "weather_condition":"cloudy","max_temperature":25,"min_temperature":7,"date":"2020-04-01T12:00:00+09:00"
        }
  ''';

  late ProviderContainer container;

  setUpAll(() {
    container = ProviderContainer(
      overrides: [yumemiWeatherClientProvider.overrideWithValue(mockClient)],
    );
  });

  tearDownAll(() {
    container.dispose();
  });

  test('success case: WeatherResponse', () async {
    when(mockClient.fetchWeather(any)).thenReturn(jsonString);

    final expected = WeatherResponse(
      weatherCondition: WeatherKind.cloudy,
      maxTemperature: 25,
      minTemperature: 7,
      date: DateTime.utc(
        2020,
        04,
        01,
        03,
      ),
    );
    await container.read(weatherResponseNotifierProvider.notifier).fetch();

    final actualState = container.read(weatherResponseNotifierProvider);
    expect(actualState, expected);
  });

  group(
    'Failure cases: WeatherResponseNotifier',
    () {
      test(
        'failure case `invalidParameter`: WeatherResponse',
        () {
          when(mockClient.fetchWeather(any))
              .thenThrow(YumemiWeatherError.invalidParameter);

          expect(
            container.read(weatherResponseNotifierProvider.notifier).fetch,
            throwsA(YumemiWeatherError.invalidParameter),
          );
        },
      );

      test(
        'failure case `unknown`: WeatherResponse',
        () {
          when(mockClient.fetchWeather(any))
              .thenThrow(YumemiWeatherError.unknown);

          expect(
            container.read(weatherResponseNotifierProvider.notifier).fetch,
            throwsA(YumemiWeatherError.unknown),
          );
        },
      );
    },
  );
}
