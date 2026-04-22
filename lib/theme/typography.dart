import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tokens.dart';

class LALTypography {
  LALTypography._();

  // Fraunces serif — display & headline
  static TextStyle get displayLarge => GoogleFonts.fraunces(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        color: LALColors.c900,
        height: 1.1,
      );

  static TextStyle get displayMedium => GoogleFonts.fraunces(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: LALColors.c900,
        height: 1.15,
      );

  static TextStyle get headlineLarge => GoogleFonts.fraunces(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: LALColors.c900,
        height: 1.2,
      );

  static TextStyle get headlineMedium => GoogleFonts.fraunces(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: LALColors.c900,
        height: 1.25,
      );

  static TextStyle get headlineSmall => GoogleFonts.fraunces(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: LALColors.c900,
        height: 1.3,
      );

  // Inter / system — body & labels
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: LALColors.c900,
    height: 1.5,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: LALColors.c700,
    height: 1.5,
  );

  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: LALColors.c500,
    height: 1.4,
  );

  static const labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: LALColors.c900,
    letterSpacing: 0.1,
  );

  static const labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: LALColors.c700,
    letterSpacing: 0.2,
  );

  static const labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: LALColors.c500,
    letterSpacing: 0.5,
  );
}
