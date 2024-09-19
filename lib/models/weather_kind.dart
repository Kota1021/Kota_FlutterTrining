import 'package:flutter_svg/flutter_svg.dart';

enum WeatherKind { sunny, cloudy, rainy }

extension WeatherKindIcon on WeatherKind {
  SvgPicture get svgImage => switch (this) {
        WeatherKind.sunny => SvgPicture.asset('images/Sunny.svg'),
        WeatherKind.cloudy => SvgPicture.asset('images/Cloudy.svg'),
        WeatherKind.rainy => SvgPicture.asset('images/Rainy.svg'),
      };
}
