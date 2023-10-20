
import 'package:flutter/material.dart';

class Utils{
  static Color shiftColor(Color color, double shift) {
    if(shift == 1) {
      return color;
    }

    final hsvColor = HSVColor.fromColor(color).withSaturation(shift);
    return hsvColor.toColor();
  }
}