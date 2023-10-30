
class NLyric {
  final LyricData? lrc;
  final LyricData? klyric;
  final LyricData? tlyric;

  NLyric({required this.lrc, required this.klyric, required this.tlyric});

  Map<String, dynamic> toMap() {
    return {
      'lrc': lrc,
      'klyric': klyric,
      'tlyric': tlyric,
    };
  }

  factory NLyric.fromMap(dynamic map) {
    return NLyric(
      lrc: LyricData.fromMap(map['lrc']),
      klyric: LyricData.fromMap(map['klyric']),
      tlyric: LyricData.fromMap(map['tlyric']),
    );
  }
}

class LyricData{
  final int version;
  final String? lyric;

  LyricData({required this.version, required this.lyric});


  @override
  String toString() {
    return 'LyricData{version: $version, lyric: $lyric}';
  }

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'lyric': lyric,
    };
  }

  factory LyricData.fromMap(dynamic json) {
    return LyricData(
      version: json['version'] as int,
      lyric: json['lyric'] as String?,
    );
  }
}