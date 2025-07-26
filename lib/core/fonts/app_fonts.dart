// app_fonts.dart
import 'package:flutter/material.dart';

enum AppFont {
  airstrike,
  airstrike3d,
  airstrikeBold3d,
  fonarito,
  fonartoXT,
  orbitronMedium,
  orbitronRegular,
  pirulentBold,
}

class AppFonts {
  // Mapeo de enum a nombre de fuente
  static const Map<AppFont, String> _fontMap = {
    AppFont.airstrike: 'Airstrike',
    AppFont.airstrike3d: 'Airstrike3D',
    AppFont.airstrikeBold3d: 'AirstrikeBold3D',
    AppFont.fonarito: 'Fonarto',
    AppFont.fonartoXT: 'FonartoXT',
    AppFont.orbitronMedium: 'Orbitron-Medium',
    AppFont.orbitronRegular: 'Orbitron-Regular',
    AppFont.pirulentBold: 'Pirulent',
  };

  // Método principal para obtener el nombre de la fuente
  static String getFontFamily(AppFont font) {
    return _fontMap[font] ?? 'Airstrike';
  }

  // Método simple para crear TextStyle
  static TextStyle getTextStyle(
    AppFont font, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return TextStyle(
      fontFamily: getFontFamily(font),
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }

  // Obtener todas las fuentes disponibles
  static List<AppFont> getAvailableFonts() {
    return AppFont.values;
  }

  // Obtener nombre legible de la fuente
  static String getFontDisplayName(AppFont font) {
    return _fontMap[font] ?? 'Unknown Font';
  }
}

// Extensión para uso más simple
extension AppFontExtension on AppFont {
  String get fontFamily => AppFonts.getFontFamily(this);
  
  TextStyle style({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return AppFonts.getTextStyle(
      this,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }
}
