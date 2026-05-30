// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Track _$TrackFromJson(Map<String, dynamic> json) => Track(
  surah: Surah.fromJson(json['surah'] as Map<String, dynamic>),
  reciter: Reciter.fromJson(json['reciter'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
  'surah': instance.surah.toJson(),
  'reciter': instance.reciter.toJson(),
};
