import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyleText {
  TextStyle openSansBold({required color, required size, required bool weightfont}){
    return GoogleFonts.openSans(
        color: color,
        fontSize: size,
        fontWeight: weightfont ? FontWeight.bold : FontWeight.normal
    );
  }

  TextStyle poppinsBold({required color, required size, required bool weightfont}){
    return GoogleFonts.openSans(
        color: color,
        fontSize: size,
        fontWeight: weightfont ? FontWeight.bold : FontWeight.normal
    );
  }
}