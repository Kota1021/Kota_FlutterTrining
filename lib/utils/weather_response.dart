import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_training/weather_kind.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_response.freezed.dart';
part 'weather_response.g.dart';

@freezed
class WeatherResponse with _$WeatherResponse {
  @WeatherKindConverter()
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

class WeatherKindConverter implements JsonConverter<WeatherKind?, String?> {
  const WeatherKindConverter();

  @override
  WeatherKind fromJson(String? json) {
    final kind = EnumToString.fromString(WeatherKind.values, json ?? '');
    if (kind == null) {
      throw FormatException('Invalid WeatherKind value: $json');
    }
    return kind;
  }

  @override
  String? toJson(WeatherKind? object) {
    return object == null ? null : EnumToString.convertToString(object);
  }
}
