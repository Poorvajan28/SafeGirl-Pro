import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightModeColors {
  // Modern gradient primary colors - Vibrant Purple to Pink
  static const lightPrimary = Color(0xFFB621FE);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFF5EBFF);
  static const lightOnPrimaryContainer = Color(0xFF4A0E66);
  static const lightSecondary = Color(0xFF0EA5E9);
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightTertiary = Color(0xFFFF2D92);
  static const lightOnTertiary = Color(0xFFFFFFFF);
  static const lightError = Color(0xFFFF4757);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightErrorContainer = Color(0xFFFFE4E8);
  static const lightOnErrorContainer = Color(0xFF990022);
  static const lightSuccess = Color(0xFF06D6A0);
  static const lightWarning = Color(0xFFFFAA00);
  static const lightInversePrimary = Color(0xFFE0B3FF);
  static const lightShadow = Color(0xFF000000);
  static const lightSurface = Color(0xFFFAFBFF);
  static const lightOnSurface = Color(0xFF1A1C1E);
  static const lightAppBarBackground = Color(0xFFFFFFFF);
  static const lightCardBackground = Color(0xFFFFFFFF);
}

class DarkModeColors {
  static const darkPrimary = Color(0xFFD896FF);
  static const darkOnPrimary = Color(0xFF4A0E66);
  static const darkPrimaryContainer = Color(0xFF8B3DBE);
  static const darkOnPrimaryContainer = Color(0xFFF5EBFF);
  static const darkSecondary = Color(0xFF38BDF8);
  static const darkOnSecondary = Color(0xFF00384D);
  static const darkTertiary = Color(0xFFFF5FA2);
  static const darkOnTertiary = Color(0xFF66001F);
  static const darkError = Color(0xFFFF6B7A);
  static const darkOnError = Color(0xFF66000D);
  static const darkErrorContainer = Color(0xFFCC1439);
  static const darkOnErrorContainer = Color(0xFFFFE4E8);
  static const darkSuccess = Color(0xFF2AFABD);
  static const darkWarning = Color(0xFFFFBB33);
  static const darkInversePrimary = Color(0xFFB621FE);
  static const darkShadow = Color(0xFF000000);
  static const darkSurface = Color(0xFF121318);
  static const darkOnSurface = Color(0xFFE3E4E9);
  static const darkAppBarBackground = Color(0xFF1E1F26);
  static const darkCardBackground = Color(0xFF1E1F26);
}

class FontSizes {
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 24.0;
  static const double headlineSmall = 22.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 18.0;
  static const double titleSmall = 16.0;
  static const double labelLarge = 16.0;
  static const double labelMedium = 14.0;
  static const double labelSmall = 12.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
}

ThemeData get lightTheme => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: LightModeColors.lightPrimary,
        onPrimary: LightModeColors.lightOnPrimary,
        primaryContainer: LightModeColors.lightPrimaryContainer,
        onPrimaryContainer: LightModeColors.lightOnPrimaryContainer,
        secondary: LightModeColors.lightSecondary,
        onSecondary: LightModeColors.lightOnSecondary,
        tertiary: LightModeColors.lightTertiary,
        onTertiary: LightModeColors.lightOnTertiary,
        error: LightModeColors.lightError,
        onError: LightModeColors.lightOnError,
        errorContainer: LightModeColors.lightErrorContainer,
        onErrorContainer: LightModeColors.lightOnErrorContainer,
        inversePrimary: LightModeColors.lightInversePrimary,
        shadow: LightModeColors.lightShadow,
        surface: LightModeColors.lightSurface,
        onSurface: LightModeColors.lightOnSurface,
      ),
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        backgroundColor: LightModeColors.lightAppBarBackground,
        foregroundColor: LightModeColors.lightOnPrimaryContainer,
        elevation: 0,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(
            fontSize: FontSizes.displayLarge, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.spaceGrotesk(
            fontSize: FontSizes.displayMedium, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.spaceGrotesk(
            fontSize: FontSizes.displaySmall, fontWeight: FontWeight.w600),
        headlineLarge: GoogleFonts.spaceGrotesk(
            fontSize: FontSizes.headlineLarge, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.spaceGrotesk(
            fontSize: FontSizes.headlineMedium, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.spaceGrotesk(
            fontSize: FontSizes.headlineSmall, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.inter(
            fontSize: FontSizes.titleLarge, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.inter(
            fontSize: FontSizes.titleMedium, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.inter(
            fontSize: FontSizes.titleSmall, fontWeight: FontWeight.w500),
        labelLarge: GoogleFonts.inter(
            fontSize: FontSizes.labelLarge, fontWeight: FontWeight.w500),
        labelMedium: GoogleFonts.inter(
            fontSize: FontSizes.labelMedium, fontWeight: FontWeight.w500),
        labelSmall: GoogleFonts.inter(
            fontSize: FontSizes.labelSmall, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.inter(
            fontSize: FontSizes.bodyLarge,
            fontWeight: FontWeight.normal,
            height: 1.5),
        bodyMedium: GoogleFonts.inter(
            fontSize: FontSizes.bodyMedium,
            fontWeight: FontWeight.normal,
            height: 1.5),
        bodySmall: GoogleFonts.inter(
            fontSize: FontSizes.bodySmall,
            fontWeight: FontWeight.normal,
            height: 1.5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          foregroundColor: LightModeColors.lightOnPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: const BorderSide(color: LightModeColors.lightPrimary),
          foregroundColor: LightModeColors.lightPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: LightModeColors.lightCardBackground,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LightModeColors.lightPrimaryContainer.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );

ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: DarkModeColors.darkPrimary,
        onPrimary: DarkModeColors.darkOnPrimary,
        primaryContainer: DarkModeColors.darkPrimaryContainer,
        onPrimaryContainer: DarkModeColors.darkOnPrimaryContainer,
        secondary: DarkModeColors.darkSecondary,
        onSecondary: DarkModeColors.darkOnSecondary,
        tertiary: DarkModeColors.darkTertiary,
        onTertiary: DarkModeColors.darkOnTertiary,
        error: DarkModeColors.darkError,
        onError: DarkModeColors.darkOnError,
        errorContainer: DarkModeColors.darkErrorContainer,
        onErrorContainer: DarkModeColors.darkOnErrorContainer,
        inversePrimary: DarkModeColors.darkInversePrimary,
        shadow: DarkModeColors.darkShadow,
        surface: DarkModeColors.darkSurface,
        onSurface: DarkModeColors.darkOnSurface,
      ),
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        backgroundColor: DarkModeColors.darkAppBarBackground,
        foregroundColor: DarkModeColors.darkOnPrimaryContainer,
        elevation: 0,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(
            fontSize: FontSizes.displayLarge, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.spaceGrotesk(
            fontSize: FontSizes.displayMedium, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.spaceGrotesk(
            fontSize: FontSizes.displaySmall, fontWeight: FontWeight.w600),
        headlineLarge: GoogleFonts.spaceGrotesk(
            fontSize: FontSizes.headlineLarge, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.spaceGrotesk(
            fontSize: FontSizes.headlineMedium, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.spaceGrotesk(
            fontSize: FontSizes.headlineSmall, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.inter(
            fontSize: FontSizes.titleLarge, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.inter(
            fontSize: FontSizes.titleMedium, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.inter(
            fontSize: FontSizes.titleSmall, fontWeight: FontWeight.w500),
        labelLarge: GoogleFonts.inter(
            fontSize: FontSizes.labelLarge, fontWeight: FontWeight.w500),
        labelMedium: GoogleFonts.inter(
            fontSize: FontSizes.labelMedium, fontWeight: FontWeight.w500),
        labelSmall: GoogleFonts.inter(
            fontSize: FontSizes.labelSmall, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.inter(
            fontSize: FontSizes.bodyLarge,
            fontWeight: FontWeight.normal,
            height: 1.5),
        bodyMedium: GoogleFonts.inter(
            fontSize: FontSizes.bodyMedium,
            fontWeight: FontWeight.normal,
            height: 1.5),
        bodySmall: GoogleFonts.inter(
            fontSize: FontSizes.bodySmall,
            fontWeight: FontWeight.normal,
            height: 1.5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          foregroundColor: DarkModeColors.darkOnPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: const BorderSide(color: DarkModeColors.darkPrimary),
          foregroundColor: DarkModeColors.darkPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: DarkModeColors.darkCardBackground,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DarkModeColors.darkPrimaryContainer.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
