import 'package:flutter_aplayer/extension.dart';

import '../main.dart';

class LrcParser {
  List<LyricRow> getLrcRows(String? allContent) {
    final lrcRows = <LyricRow>[];
    final allLine = <String>[];
    Duration offset = Duration.zero;
    if (allContent == null || allContent.isEmpty) {
      return lrcRows;
    }

    allContent.split('\n').forEach((eachLine) {
      allLine.add(eachLine);
      if (eachLine.startsWith('[offset:') && eachLine.endsWith(']')) {
        final offsetInStr = eachLine.substring(
            eachLine.lastIndexOf(':') + 1, eachLine.length - 1);
        if (offsetInStr.isNotEmpty && int.tryParse(offsetInStr) != null) {
          offset = Duration(milliseconds: int.parse(offsetInStr));
        }
      }
    });

    if (allLine.isEmpty) {
      return lrcRows;
    }

    for (final temp in allLine) {
      final rows = LyricRow.createLrcRows(temp, offset);
      if (rows != null && rows.isNotEmpty) {
        lrcRows.addAll(rows);
      }
    }

    lrcRows.sort((a, b) => a.time.inMilliseconds - b.time.inMilliseconds);

    final combineLrcRows = <LyricRow>[];
    var index = 0;
    while (index < lrcRows.length) {
      final currentRow = lrcRows[index];
      final nextRow = lrcRows.getOrNull(index + 1);
      if (currentRow.time == nextRow?.time && currentRow.content.isNotEmpty) {
        final tmp = LyricRow.empty();
        tmp.content = currentRow.content;
        tmp.time = currentRow.time;
        tmp.timeStr = currentRow.timeStr;
        tmp.translate = nextRow!.content;
        combineLrcRows.add(tmp);
        index++;
      } else {
        combineLrcRows.add(currentRow);
      }
      index++;
    }

    lrcRows.clear();
    lrcRows.addAll(combineLrcRows);

    if (lrcRows.isEmpty) {
      return lrcRows;
    }

    lrcRows.sort((a, b) => a.time.inMilliseconds - b.time.inMilliseconds);
    for (int i = 0; i < lrcRows.length - 1; i++) {
      final lrcRow = lrcRows[i];
      lrcRow.totalTime = lrcRows[i + 1].time - lrcRow.time;
    }

    return lrcRows;
  }
}

class LyricRow {
  String timeStr = '';
  Duration time = Duration.zero;
  Duration totalTime = Duration.zero;

  String content = '';
  double contentHeight = 0;

  String translate = '';
  double translateHeight = 0;

  double totalHeight = 0;

  LyricRow.empty();

  LyricRow(this.timeStr, this.time, String content) {
    if (content.isEmpty) {
      this.content = "";
      translate = "";
      return;
    }
    final contents = content.split('\t');
    this.content = contents[0];
    if (contents.length > 1) {
      translate = contents[1];
    }
  }

  bool hasTranslate() {
    return translate.isNotEmpty;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LyricRow &&
          runtimeType == other.runtimeType &&
          time == other.time &&
          content == other.content &&
          translate == other.translate;

  @override
  int get hashCode => time.hashCode ^ content.hashCode ^ translate.hashCode;

  static List<LyricRow>? createLrcRows(String lrcLine, Duration offset) {
    if (!lrcLine.startsWith("[") || !lrcLine.contains("]")) {
      return null;
    }

    final lastIndexOfRightBracket = lrcLine.lastIndexOf("]");
    final content =
        lrcLine.substring(lastIndexOfRightBracket + 1, lrcLine.length);

    final times = lrcLine
        .substring(0, lastIndexOfRightBracket + 1)
        .replaceAll("[", "-")
        .replaceAll("]", "-");
    final List<String> timesArray = times.split("-");

    final lrcRows = <LyricRow>[];

    for (final tem in timesArray) {
      if (tem.trim().isEmpty) {
        continue;
      }
      try {
        final lrcRow = LyricRow(tem, formatTime(tem) - offset, content);
        lrcRows.add(lrcRow);
      } catch (e) {
        logger.e(e);
      }
    }
    return lrcRows;
  }

  static Duration formatTime(String str) {
    final timeStr = str.replaceAll('.', ':');
    final times = timeStr.split(':');

    if (times.length > 2) {
      return Duration(milliseconds: int.parse(times[0]) * 60 * 1000 +
          int.parse(times[1]) * 1000 +
          int.parse(times[2]));
    } else {
      return Duration(milliseconds: int.parse(times[0]) * 60 * 1000 + int.parse(times[1]) * 1000);
    }
  }
}
