class AppUtils {
  AppUtils._();

  /// Formats a [Duration] to mm:ss string
  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Builds the audio URL for a given [edition] and [surahNumber] from
  /// the Alquran.cloud CDN.
  ///
  /// Example: edition='ar.alafasy', surahNumber=1 →
  /// 'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/1.mp3'
  static String buildSurahAudioUrl({
    required String edition,
    required int surahNumber,
  }) {
    return 'https://cdn.islamic.network/quran/audio-surah/128/$edition/$surahNumber.mp3';
  }
}