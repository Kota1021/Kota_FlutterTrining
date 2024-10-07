import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_training/models/weather_kind.dart';
import 'package:flutter_training/repositories/weather_response_repository.dart';
import 'package:flutter_training/screens/weather_info/weather_info_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

import 'weather_response_notifier_test.mocks.dart';

void main() {
  final mockYumemiWeather = MockYumemiWeather();
  const sunnyJsonData = '''
        {
          "weather_condition": "sunny",
          "max_temperature": 30, 
          "min_temperature": 15,
          "date": "2024-06-19T00:00:00.000"
        }
        ''';

  const cloudyJsonData = '''
        {
          "weather_condition": "cloudy",
          "max_temperature": 20, 
          "min_temperature": 10,
          "date": "2024-06-19T00:00:00.000"
        }
        ''';

  const rainyJsonData = '''
        {
          "weather_condition": "rainy",
          "max_temperature": 15, 
          "min_temperature": 5,
          "date": "2024-06-19T00:00:00.000"
        }
        ''';

  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  void setDisplaySize({
    Size size = const Size(390, 844),
  }) {
    binding.platformDispatcher.implicitView!.physicalSize = size;
    binding.platformDispatcher.implicitView!.devicePixelRatio = 1;
  }

  setDisplaySize();
  testWidgets('check WeatherInfoScreen before fetch', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: WeatherInfoScreen(),
        ),
      ),
    );

    expect(find.byType(Placeholder), findsOneWidget);
    expect(find.text('** ℃'), findsNWidgets(2));
    expect(find.byKey(const Key('closeButton')), findsOneWidget);
    expect(find.byKey(const Key('reloadButton')), findsOneWidget);
  });

  testWidgets('check WeatherInfoScreen on sunny weather', (tester) async {
    when(
      mockYumemiWeather.fetchWeather(any),
    ).thenAnswer(
      (_) => sunnyJsonData,
    );
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          yumemiWeatherClientProvider.overrideWithValue(mockYumemiWeather),
        ],
        child: const MaterialApp(
          home: WeatherInfoScreen(),
        ),
      ),
    );

    final reloadButton = find.byKey(const Key('reloadButton'));
    expect(reloadButton, findsOneWidget);

    await tester.tap(reloadButton);
    await tester.pump();

    expect(find.bySemanticsLabel(WeatherKindIcon.sunnyLabel), findsOneWidget);
    expect(find.text('30 ℃'), findsOneWidget);
    expect(find.text('15 ℃'), findsOneWidget);
    expect(find.byKey(const Key('closeButton')), findsOneWidget);
  });

  group('check WeatherInfoScreen', () {
    testWidgets('check WeatherInfoScreen on cloudy weather', (tester) async {
      when(
        mockYumemiWeather.fetchWeather(any),
      ).thenAnswer(
        (_) => cloudyJsonData,
      );
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            yumemiWeatherClientProvider.overrideWithValue(mockYumemiWeather),
          ],
          child: const MaterialApp(
            home: WeatherInfoScreen(),
          ),
        ),
      );

      final reloadButton = find.byKey(const Key('reloadButton'));
      expect(reloadButton, findsOneWidget);

      await tester.tap(reloadButton);
      await tester.pump();

      expect(
        find.bySemanticsLabel(WeatherKindIcon.cloudyLabel),
        findsOneWidget,
      );
      expect(find.text('20 ℃'), findsOneWidget);
      expect(find.text('10 ℃'), findsOneWidget);
      expect(find.byKey(const Key('closeButton')), findsOneWidget);
    });

    testWidgets('check WeatherInfoScreen on rainy weather', (tester) async {
      when(
        mockYumemiWeather.fetchWeather(any),
      ).thenAnswer(
        (_) => rainyJsonData,
      );
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            yumemiWeatherClientProvider.overrideWithValue(mockYumemiWeather),
          ],
          child: const MaterialApp(
            home: WeatherInfoScreen(),
          ),
        ),
      );

      final reloadButton = find.byKey(const Key('reloadButton'));
      expect(reloadButton, findsOneWidget);

      await tester.tap(reloadButton);
      await tester.pump();

      expect(find.bySemanticsLabel(WeatherKindIcon.rainyLabel), findsOneWidget);
      expect(find.text('15 ℃'), findsOneWidget);
      expect(find.text('5 ℃'), findsOneWidget);
      expect(find.byKey(const Key('closeButton')), findsOneWidget);
    });

    testWidgets('check WeatherInfoScreen on unknown error', (tester) async {
      when(
        mockYumemiWeather.fetchWeather(any),
      ).thenThrow(YumemiWeatherError.unknown);

      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            yumemiWeatherClientProvider.overrideWithValue(mockYumemiWeather),
          ],
          child: const MaterialApp(
            home: WeatherInfoScreen(),
          ),
        ),
      );

      final reloadButton = find.byKey(const Key('reloadButton'));
      expect(reloadButton, findsOneWidget);

      // present error dialog
      await tester.tap(reloadButton);
      await tester.pump();

      final errorDialog = find.widgetWithText(
        AlertDialog,
        YumemiWeatherError.unknown.toString(),
      );
      expect(errorDialog, findsOneWidget);

      // close error dialog
      final confirmationButton = find.byKey(const Key('confirmationButton'));
      expect(confirmationButton, findsOneWidget);
      await tester.tap(confirmationButton);
      await tester.pump();
      expect(errorDialog, findsNothing);
    });

    testWidgets('check WeatherInfoScreen on invalidParameter error',
        (tester) async {
      when(
        mockYumemiWeather.fetchWeather(any),
      ).thenThrow(YumemiWeatherError.invalidParameter);

      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            yumemiWeatherClientProvider.overrideWithValue(mockYumemiWeather),
          ],
          child: const MaterialApp(
            home: WeatherInfoScreen(),
          ),
        ),
      );

      final reloadButton = find.byKey(const Key('reloadButton'));
      expect(reloadButton, findsOneWidget);

      // present error dialog
      await tester.tap(reloadButton);
      await tester.pump();

      final errorDialog = find.widgetWithText(
        AlertDialog,
        YumemiWeatherError.invalidParameter.toString(),
      );
      expect(errorDialog, findsOneWidget);

      // close error dialog
      final confirmationButton = find.byKey(const Key('confirmationButton'));
      expect(confirmationButton, findsOneWidget);
      await tester.tap(confirmationButton);
      await tester.pump();
      expect(errorDialog, findsNothing);
    });
  });
}
