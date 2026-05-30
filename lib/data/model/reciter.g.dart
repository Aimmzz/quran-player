// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reciter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reciter _$ReciterFromJson(Map<String, dynamic> json) => Reciter(
  identifier: json['identifier'] as String,
  language: json['language'] as String,
  name: json['englishName'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$ReciterToJson(Reciter instance) => <String, dynamic>{
  'identifier': instance.identifier,
  'language': instance.language,
  'englishName': instance.name,
  'type': instance.type,
};
