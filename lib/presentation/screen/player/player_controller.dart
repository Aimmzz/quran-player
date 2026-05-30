import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranplayer/data/model/track.dart';
import 'package:quranplayer/data/service/audio_service.dart';

class PlayerController extends GetxController {
  final AudioService _audioService;

  PlayerController(this._audioService);

  late final Track track;

  final RxBool isSeeking = false.obs;

  final Rx<Duration> seekPosition = Rx<Duration>(Duration.zero);

  PlaybackState get playbackState => _audioService.playbackState.value;
  Duration get position => isSeeking.value
      ? seekPosition.value
      : _audioService.position.value;
  Duration get duration => _audioService.duration.value;
  bool get isBuffering => _audioService.isBuffering.value;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is Track) {
      track = Get.arguments as Track;
    } else {
      Get.back();
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _audioService.play(track);
    });
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Public Methods ////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void togglePlayPause() {
    if (_audioService.playbackState.value == PlaybackState.playing) {
      _audioService.pause();
    } else {
      _audioService.resume();
    }
  }

  void rewind() {
    final newPos = _audioService.position.value - const Duration(seconds: 10);
    _audioService.seekTo(newPos < Duration.zero ? Duration.zero : newPos);
  }

  void fastForward() {
    final dur = _audioService.duration.value;
    final newPos = _audioService.position.value + const Duration(seconds: 10);
    _audioService.seekTo(newPos > dur ? dur : newPos);
  }

  void onSeekChanged(double value) {
    isSeeking.value = true;
    seekPosition.value = Duration(milliseconds: value.toInt());
  }

  void onSeekEnd(double value) {
    _audioService.seekTo(Duration(milliseconds: value.toInt()));
    isSeeking.value = false;
  }
}