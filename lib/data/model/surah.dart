import 'package:json_annotation/json_annotation.dart';

part 'surah.g.dart';

@JsonSerializable(explicitToJson: true)
class Surah {
  @JsonKey(name: 'number')
  final int number;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'englishName')
  final String englishName;

  @JsonKey(name: 'englishNameTranslation')
  final String englishNameTranslation;

  @JsonKey(name: 'numberOfAyahs')
  final int numberOfAyahs;

  @JsonKey(name: 'revelationType')
  final String revelationType;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory Surah.fromJson(Map<String, dynamic> json) => _$SurahFromJson(json);

  Map<String, dynamic> toJson() => _$SurahToJson(this);
}