import 'dart:math';
import 'package:flutter/material.dart';

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);

class Palette {
  static const Color primaryColor = Color(0xFF4285F4);
  static const Color redColor = Color(0xFFDB4437);
  static const Color redDarkColor = Color(0xFFB81E26);
  static const Color greenColor = Color(0xFF1DB954); //0xFF1DB954
  static const Color greendarkColor = Color(0xFF0F9D58);

  static const Color blackColor = Color(0xFF282828);
  static const Color whiteColor = Color.fromARGB(255, 255, 255, 255);

  static const Color fontWhiteColor = Color.fromARGB(255, 255, 255, 255);
  static const Color fontBlackColor = Color.fromARGB(255, 0, 0, 0);
  static const Color backgroundColor = Color.fromARGB(255, 240, 242, 245);
}
