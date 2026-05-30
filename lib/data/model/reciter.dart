import 'package:json_annotation/json_annotation.dart';

part 'reciter.g.dart';

@JsonSerializable(explicitToJson: true)
class Reciter {
  @JsonKey(name: 'identifier')
  final String identifier;

  @JsonKey(name: 'language')
  final String language;

  @JsonKey(name: 'englishName')
  final String name;

  @JsonKey(name: 'type')
  final String type;

  Reciter({
    required this.identifier,
    required this.language,
    required this.name,
    required this.type,
  });

  factory Reciter.fromJson(Map<String, dynamic> json) => _$ReciterFromJson(json);

  Map<String, dynamic> toJson() => _$ReciterToJson(this);
}