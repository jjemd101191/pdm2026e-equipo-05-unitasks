import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'theme.dart';

/// `MaterialApp` común para el arranque, el login y la app ya con sesión.
Widget taskuMaterialApp({required Widget home}) => MaterialApp(
  title: 'TaskU',
  debugShowCheckedModeBanner: false,
  theme: buildTaskuTheme(),
  locale: const Locale('es'),
  supportedLocales: const [Locale('es')],
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: home,
);
