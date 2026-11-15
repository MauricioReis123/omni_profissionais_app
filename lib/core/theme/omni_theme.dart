import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema OMNI: Dark Premium / Neon Luxuoso (#00FFCC)
/// Fidelidade 1:1 com a paleta e tipografia do Preview Web (Plus Jakarta Sans + JetBrains Mono)
class OmniTheme {
  static const Color neonGreen = Color(0xFF00FFCC);
  static const Color neonGreenDark = Color(0xFF009977);
  static const Color backgroundBlack = Color(0xFF07090C);
  static const Color surfaceCard = Color(0xFF101520);
  static const Color surfaceInner = Color(0xFF0B0F17);
  static const Color surfaceInput = Color(0xFF090D14);
  static const Color surfaceCardActive = Color(0xFF121824);
  static const Color borderSubtle = Color(0x1AFFFFFF);
  static const Color borderFaint = Color(0x0DFFFFFF);
  static const Color textPrimary = Color(0xFFE2E8F0);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color alertAmber = Color(0xFFFBBF24);
  static const Color alertEmerald = Color(0xFF34D399);
  static const Color alertCrimson = Color(0xFFFB7185);
  static const Color infoSky = Color(0xFF38BDF8);

  static List<BoxShadow> neonGlow({double opacity = 0.22, double blur = 14}) => [
        BoxShadow(
          color: neonGreen.withOpacity(opacity),
          blurRadius: blur,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> amberGlow({double opacity = 0.20, double blur = 12}) => [
        BoxShadow(
          color: alertAmber.withOpacity(opacity),
          blurRadius: blur,
          spreadRadius: 0,
        ),
      ];

  static ThemeData get darkTheme {
    final baseText = ThemeData.dark().textTheme.apply(
          bodyColor: textPrimary,
          displayColor: textPrimary,
        );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundBlack,
      primaryColor: neonGreen,
      colorScheme: const ColorScheme.dark(
        primary: neonGreen,
        secondary: neonGreenDark,
        surface: surfaceCard,
        error: alertCrimson,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(baseText),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundBlack,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: neonGreen),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonGreen,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: borderSubtle),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceInput,
        hintStyle: const TextStyle(color: textMuted, fontSize: 12),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: neonGreen, width: 1.5),
        ),
      ),
    );
  }
}
