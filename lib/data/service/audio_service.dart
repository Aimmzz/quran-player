import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:quranplayer/data/model/track.dart';

/// Playback states for the audio player.
enum PlaybackState { idle, loading, playing, paused, stopped, error }

class AudioService extends GetxService {
  final AudioPlayer _player = AudioPlayer();

  final Rx<Track?> currentTrack = Rx<Track?>(null);
  final Rx<PlaybackState> playbackState = Rx<PlaybackState>(PlaybackState.idle);
  final Rx<Duration> position = Rx<Duration>(Duration.zero);
  final Rx<Duration> duration = Rx<Duration>(Duration.zero);
  final RxBool isBuffering = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _configureAudioSession();
    _bindStreams();
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }

  Future<void> play(Track track) async {
    final isSameTrack = currentTrack.value != null &&
        currentTrack.value!.surah.number == track.surah.number &&
        currentTrack.value!.reciter.identifier == track.reciter.identifier;

    if (isSameTrack) {
      await resume();
      return;
    }

    currentTrack.value = track;

    try {
      await _player.setUrl(track.audioUrl);
      await _player.play();
    } catch (e) {
      playbackState.value = PlaybackState.error;
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
    currentTrack.value = null;
    playbackState.value = PlaybackState.stopped;
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
  }

  Future<void> _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  void _bindStreams() {
    _player.positionStream.listen((pos) {
      position.value = pos;
    });

    _player.durationStream.listen((dur) {
      if (dur != null) duration.value = dur;
    });

    _player.playerStateStream.listen((state) {
      final processing = state.processingState;

      isBuffering.value = processing == ProcessingState.buffering ||
          processing == ProcessingState.loading;

      if (processing == ProcessingState.completed) {
        playbackState.value = PlaybackState.stopped;
        _player.seek(Duration.zero);
        return;
      }

      if (processing == ProcessingState.idle) {
        playbackState.value = PlaybackState.idle;
        return;
      }

      if (state.playing) {
        playbackState.value = PlaybackState.playing;
      } else {
        if (playbackState.value != PlaybackState.loading) {
          playbackState.value = PlaybackState.paused;
        }
      }
    });
  }
}