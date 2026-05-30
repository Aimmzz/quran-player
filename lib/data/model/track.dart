import 'package:json_annotation/json_annotation.dart';
import 'package:quranplayer/core/utils/app_utils.dart';
import 'package:quranplayer/data/model/reciter.dart';
import 'package:quranplayer/data/model/surah.dart';

part 'track.g.dart';

@JsonSerializable(explicitToJson: true)
class Track {
  @JsonKey(name: 'surah')
  final Surah surah;

  @JsonKey(name: 'reciter')
  final Reciter reciter;

  Track({
    required this.surah,
    required this.reciter,
  });

  String get audioUrl => AppUtils.buildSurahAudioUrl(
    edition: reciter.identifier,
    surahNumber: surah.number,
  );

  String get title => surah.englishName;
  String get subtitle => reciter.name;
  String get arabicTitle => surah.name;

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

  Map<String, dynamic> toJson() => _$TrackToJson(this);
}