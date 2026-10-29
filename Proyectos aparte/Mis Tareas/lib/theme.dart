import 'package:flutter/material.dart';

const kFondo = Color(0xFFFCFBFF);
const kTexto = Color(0xFF202124);
const kMuted = Color(0xFF686A73);
const kMorado = Color(0xFF7352D6);
const kMoradoClaro = Color(0xFFF0ECFF);
const kBorde = Color(0xFFE8E5EE);

// Alias para que los componentes de cursos usen la paleta de Mis Tareas.
const kIndigo = kMorado;
const kIndigoDark = kMorado;
const kIndigoSoft = kMoradoClaro;
const kInk = kTexto;
const kLine = kBorde;
const kSoftBg = kFondo;
const kSky = Colors.blue;
const kGreen = Colors.green;
const kAmber = Color(0xFFF59E0B);
const kPink = Color(0xFFEC4899);
const kSlate = kMuted;
const kRed = Color(0xFFDC2626);
const kRedSoft = Color(0xFFFEE2E2);

ThemeData buildMisTareasTheme() => ThemeData(
  scaffoldBackgroundColor: kFondo,
  colorScheme: ColorScheme.fromSeed(seedColor: kMorado),
);
