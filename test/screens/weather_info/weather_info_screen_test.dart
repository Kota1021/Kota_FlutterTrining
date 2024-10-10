import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_training/models/weather_kind.dart';
import 'package:flutter_training/models/weather_response.dart';
import 'package:flutter_training/repositories/weather_response_repository.dart';
import 'package:flutter_training/screens/weather_info/weather_info_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

import 'weather_info_screen_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WeatherResponseRepository>()])
void main() {
  final mockRepository = MockWeatherResponseRepository();
  final sunnyWeather = WeatherResponse(
    weatherCondition: WeatherKind.sunny,
    maxTemperature: 30,
    minTemperature: 15,
    date: DateTime.utc(2024, 6, 19),
  );

  final cloudyWeather = WeatherResponse(
    weatherCondition: WeatherKind.cloudy,
    maxTemperature: 20,
    minTemperature: 10,
    date: DateTime.utc(2024, 6, 19),
  );

  final rainyWeather = WeatherResponse(
    weatherCondition: WeatherKind.rainy,
    maxTemperature: 15,
    minTemperature: 5,
    date: DateTime.utc(2024, 6, 19),
  );

  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  void setDisplaySize({
    Size size = const Size(390, 844),
  }) {
    binding.platformDispatcher.implicitView!.physicalSize = size;
    binding.platformDispatcher.implicitView!.devicePixelRatio = 1;
  }

  Future<void> pumpWidget(WidgetTester tester, List<Override> overrides) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: const MaterialApp(
          home: WeatherInfoScreen(),
        ),
      ),
    );
  }

  setDisplaySize();
  group('check WeatherInfoScreen', () {
    testWidgets('check WeatherInfoScreen before fetch', (tester) async {
      await pumpWidget(tester, []);

      expect(find.byType(Placeholder), findsOneWidget);
      expect(find.text('** ℃'), findsNWidgets(2));
      expect(find.byKey(WeatherInfoScreen.closeButton), findsOneWidget);
      expect(find.byKey(WeatherInfoScreen.reloadButton), findsOneWidget);
    });

    testWidgets('check WeatherInfoScreen on sunny weather', (tester) async {
      final completer = Completer<WeatherResponse>();
      when(
        mockRepository.fetch(),
      ).thenAnswer(
        (_) => completer.future,
      );
      // Create the widget by telling the tester to build it.
      await pumpWidget(
        tester,
        [weatherResponseRepositoryProvider.overrideWithValue(mockRepository)],
      );

      final reloadButton = find.byKey(WeatherInfoScreen.reloadButton);
      expect(reloadButton, findsOneWidget);

      await tester.tap(reloadButton);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(sunnyWeather);
      await tester.pump();

      expect(find.bySemanticsLabel(WeatherKindIcon.sunnyLabel), findsOneWidget);
      expect(find.text('30 ℃'), findsOneWidget);
      expect(find.text('15 ℃'), findsOneWidget);
      expect(find.byKey(WeatherInfoScreen.closeButton), findsOneWidget);
    });

    testWidgets('check WeatherInfoScreen on cloudy weather', (tester) async {
      final completer = Completer<WeatherResponse>();
      when(
        mockRepository.fetch(),
      ).thenAnswer(
        (_) => completer.future,
      );
      // Create the widget by telling the tester to build it.
      await pumpWidget(
        tester,
        [weatherResponseRepositoryProvider.overrideWithValue(mockRepository)],
      );

      final reloadButton = find.byKey(WeatherInfoScreen.reloadButton);
      expect(reloadButton, findsOneWidget);

      await tester.tap(reloadButton);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(cloudyWeather);
      await tester.pump();

      expect(
        find.bySemanticsLabel(WeatherKindIcon.cloudyLabel),
        findsOneWidget,
      );
      expect(find.text('20 ℃'), findsOneWidget);
      expect(find.text('10 ℃'), findsOneWidget);
      expect(find.byKey(WeatherInfoScreen.closeButton), findsOneWidget);
    });

    testWidgets('check WeatherInfoScreen on rainy weather', (tester) async {
      final completer = Completer<WeatherResponse>();
      when(
        mockRepository.fetch(),
      ).thenAnswer(
        (_) => completer.future,
      );
      // Create the widget by telling the tester to build it.
      await pumpWidget(
        tester,
        [weatherResponseRepositoryProvider.overrideWithValue(mockRepository)],
      );

      final reloadButton = find.byKey(WeatherInfoScreen.reloadButton);
      expect(reloadButton, findsOneWidget);

      await tester.tap(reloadButton);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(rainyWeather);
      await tester.pump();
      expect(find.bySemanticsLabel(WeatherKindIcon.rainyLabel), findsOneWidget);
      expect(find.text('15 ℃'), findsOneWidget);
      expect(find.text('5 ℃'), findsOneWidget);
      expect(find.byKey(WeatherInfoScreen.closeButton), findsOneWidget);
    });

    testWidgets('check WeatherInfoScreen on unknown error', (tester) async {
      final completer = Completer<WeatherResponse>();
      when(
        mockRepository.fetch(),
      ).thenAnswer(
        (_) => completer.future,
      );
      // Create the widget by telling the tester to build it.
      await pumpWidget(
        tester,
        [weatherResponseRepositoryProvider.overrideWithValue(mockRepository)],
      );

      final reloadButton = find.byKey(WeatherInfoScreen.reloadButton);
      expect(reloadButton, findsOneWidget);

      // present error dialog
      await tester.tap(reloadButton);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.completeError(YumemiWeatherError.unknown);
      await tester.pump();

      final errorDialog = find.widgetWithText(
        AlertDialog,
        YumemiWeatherError.unknown.toString(),
      );
      expect(errorDialog, findsOneWidget);

      // close error dialog
      final confirmationButton =
          find.byKey(WeatherInfoScreen.confirmationButton);
      expect(confirmationButton, findsOneWidget);
      await tester.tap(confirmationButton);
      await tester.pump();
      expect(errorDialog, findsNothing);
    });

    testWidgets('check WeatherInfoScreen on invalidParameter error',
        (tester) async {
      final completer = Completer<WeatherResponse>();
      when(
        mockRepository.fetch(),
      ).thenAnswer(
        (_) => completer.future,
      );
      // Create the widget by telling the tester to build it.
      await pumpWidget(
        tester,
        [weatherResponseRepositoryProvider.overrideWithValue(mockRepository)],
      );

      final reloadButton = find.byKey(WeatherInfoScreen.reloadButton);
      expect(reloadButton, findsOneWidget);

      // present error dialog
      await tester.tap(reloadButton);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.completeError(YumemiWeatherError.invalidParameter);
      await tester.pump();

      final errorDialog = find.widgetWithText(
        AlertDialog,
        YumemiWeatherError.invalidParameter.toString(),
      );
      expect(errorDialog, findsOneWidget);

      // close error dialog
      final confirmationButton =
          find.byKey(WeatherInfoScreen.confirmationButton);
      expect(confirmationButton, findsOneWidget);
      await tester.tap(confirmationButton);
      await tester.pump();
      expect(errorDialog, findsNothing);
    });
  });
}
