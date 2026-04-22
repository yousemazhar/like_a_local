import 'package:flutter/material.dart';
import 'tokens.dart';
import 'typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: LALColors.c900,
          onPrimary: LALColors.surface,
          secondary: LALColors.accent,
          onSecondary: LALColors.surface,
          surface: LALColors.surface,
          onSurface: LALColors.c900,
          surfaceContainerHighest: LALColors.surfaceAlt,
          outline: LALColors.c200,
          error: LALColors.error,
          onError: LALColors.surface,
        ),
        scaffoldBackgroundColor: LALColors.bg,
        appBarTheme: AppBarTheme(
          backgroundColor: LALColors.surface,
          foregroundColor: LALColors.c900,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: LALTypography.headlineSmall,
          centerTitle: false,
        ),
        textTheme: TextTheme(
          displayLarge: LALTypography.displayLarge,
          displayMedium: LALTypography.displayMedium,
          headlineLarge: LALTypography.headlineLarge,
          headlineMedium: LALTypography.headlineMedium,
          headlineSmall: LALTypography.headlineSmall,
          bodyLarge: LALTypography.bodyLarge,
          bodyMedium: LALTypography.bodyMedium,
          bodySmall: LALTypography.bodySmall,
          labelLarge: LALTypography.labelLarge,
          labelMedium: LALTypography.labelMedium,
          labelSmall: LALTypography.labelSmall,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: LALColors.c900,
            foregroundColor: LALColors.surface,
            minimumSize: const Size(double.infinity, 52),
            shape: const RoundedRectangleBorder(
              borderRadius: LALRadii.mdBorder,
            ),
            textStyle: LALTypography.labelLarge.copyWith(fontSize: 16),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: LALColors.c900,
            side: const BorderSide(color: LALColors.c200),
            minimumSize: const Size(double.infinity, 52),
            shape: const RoundedRectangleBorder(
              borderRadius: LALRadii.mdBorder,
            ),
            elevation: 0,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: LALColors.accent),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: LALColors.surface,
          border: OutlineInputBorder(
            borderRadius: LALRadii.mdBorder,
            borderSide: const BorderSide(color: LALColors.c200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: LALRadii.mdBorder,
            borderSide: const BorderSide(color: LALColors.c200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: LALRadii.mdBorder,
            borderSide: const BorderSide(color: LALColors.c900, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: LALRadii.mdBorder,
            borderSide: const BorderSide(color: LALColors.error),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle: LALTypography.bodyMedium,
          hintStyle: LALTypography.bodyMedium,
        ),
        cardTheme: const CardThemeData(
          color: LALColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: LALRadii.lgBorder,
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: LALColors.surfaceAlt,
          selectedColor: LALColors.c900,
          labelStyle: LALTypography.labelMedium,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
        dividerTheme: const DividerThemeData(
          color: LALColors.c50,
          thickness: 1,
          space: 1,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: LALColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: LALRadii.xl),
          ),
        ),
      );
}
