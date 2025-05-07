import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: Colors.pink[200],
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.pink[200],
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.poppins(color: Colors.black87),
      bodyLarge: GoogleFonts.poppins(color: Colors.black),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.pink[200],
    ),
  );
}
