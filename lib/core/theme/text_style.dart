import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Headings
  static TextStyle headingLarge = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle headingMedium = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  // Body text
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    color: Colors.black54,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    color: Colors.black45,
  );

  // Button text
  static TextStyle buttonText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
