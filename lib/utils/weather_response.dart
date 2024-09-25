import 'package:flutter_training/weather_kind.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_response.freezed.dart';
part 'weather_response.g.dart';

@freezed
class WeatherResponse with _$WeatherResponse {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory WeatherResponse({
    required WeatherKind weatherCondition,
    required int maxTemperature,
    required int minTemperature,
    required DateTime date,
  }) = _WeatherResponse;

  factory WeatherResponse.fromJson(Map<String, Object?> json) =>
      _$WeatherResponseFromJson(json);
}
