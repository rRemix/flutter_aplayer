import 'package:flutter/material.dart';

class Utils {
  static Color shiftColor(Color color, double shift) {
    if (shift == 1) {
      return color;
    }

    final hsvColor = HSVColor.fromColor(color).withSaturation(shift);
    return hsvColor.toColor();
  }

  static String getTime(Duration duration) {
    if (duration == Duration.zero) {
      return '00:00';
    }
    final millSecond = duration.inMilliseconds;

    final minute = millSecond / 1000 ~/ 60;
    final second = millSecond ~/ 1000 % 60;

    if (minute < 10) {
      if (second < 10) {
        return '0$minute:0$second';
      } else {
        return '0$minute:$second';
      }
    } else {
      if (second < 10) {
        return '$minute:0$second';
      } else {
        return '$minute:$second';
      }
    }
  }
}
