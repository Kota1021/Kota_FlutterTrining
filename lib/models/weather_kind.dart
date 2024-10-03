import 'package:flutter_svg/flutter_svg.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum WeatherKind { sunny, cloudy, rainy }

extension WeatherKindIcon on WeatherKind {
  @visibleForTesting
  static const sunnyLabel = 'Sunny image';
  @visibleForTesting
  static const cloudyLabel = 'Cloudy image';
  @visibleForTesting
  static const rainyLabel = 'Rainy image';

  SvgPicture get svgImage => switch (this) {
        WeatherKind.sunny => SvgPicture.asset(
            'images/Sunny.svg',
            semanticsLabel: sunnyLabel,
          ),
        WeatherKind.cloudy => SvgPicture.asset(
            'images/Cloudy.svg',
            semanticsLabel: cloudyLabel,
          ),
        WeatherKind.rainy => SvgPicture.asset(
            'images/Rainy.svg',
            semanticsLabel: rainyLabel,
          ),
      };
}
