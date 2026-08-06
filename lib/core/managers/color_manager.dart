import 'package:flutter/material.dart';

extension HexColor on Color {
  static Color hexString(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      color = "FF$color";
    }
    return Color(int.parse(color, radix: 16));
  }
}

class ColorManager {
  static Color black = HexColor.hexString("#000000");
  static Color white = HexColor.hexString("#FFFFFF");
  static Color primary = HexColor.hexString("#C9A34A");
  static Color primary1 = HexColor.hexString("#D5BA71");
  static Color background = HexColor.hexString("#FDFCFB");
  static Color background1 = HexColor.hexString("#F7F5F1");
  static Color grey = HexColor.hexString("#919599");
  static Color grey1   = HexColor.hexString("#635B4F");
  static Color button = HexColor.hexString("#F5EEE5");
  static Color appbar = HexColor.hexString("#F5F3F0");

}