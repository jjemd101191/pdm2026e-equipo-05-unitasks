import 'package:flutter/material.dart';

/// Paleta de TaskU (tomada del mockup aprobado por el equipo).
const Color kIndigo = Color(0xFF4F46E5);
const Color kIndigoDark = Color(0xFF4338CA);
const Color kIndigoSoft = Color(0xFFEEF2FF);
const Color kInk = Color(0xFF0F172A);
const Color kMuted = Color(0xFF64748B);
const Color kLine = Color(0xFFE8EDF3);
const Color kSoftBg = Color(0xFFF8FAFC);
const Color kRed = Color(0xFFDC2626);
const Color kRedSoft = Color(0xFFFEE2E2);
const Color kAmber = Color(0xFFF59E0B);
const Color kAmberSoft = Color(0xFFFEF3C7);
const Color kAmberDark = Color(0xFFB45309);
const Color kSky = Color(0xFF0EA5E9);
const Color kSkySoft = Color(0xFFE0F2FE);
const Color kSkyDark = Color(0xFF0369A1);
const Color kGreen = Color(0xFF10B981);
const Color kGreenSoft = Color(0xFFECFDF5);
const Color kGreenDark = Color(0xFF047857);
const Color kPink = Color(0xFFEC4899);
const Color kSlate = Color(0xFF64748B);

/// Tema Material 3 de TaskU.
ThemeData buildTaskuTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: kIndigo);
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: Color(0xFF334155)),
      titleTextStyle: TextStyle(
        color: kInk,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Color(0xFFE0E7FF),
      height: 66,
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
