import 'package:flutter/material.dart';

class AppTheme{
  static ThemeData getTheme(Brightness brightness){
    final isDarkMode = brightness == Brightness.dark;


    Color modeColor=isDarkMode?Colors.black:Colors.white;
    return ThemeData(
      brightness: isDarkMode?Brightness.dark:Brightness.light,
      scaffoldBackgroundColor:modeColor,
      primarySwatch: Colors.red,
      primaryColor:isDarkMode?Colors.white:Colors.black ,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.red,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        secondary: isDarkMode?Colors.grey[800]:Colors.red, // ← you can treat this as navColor
      ),

        iconTheme:  IconThemeData(color: isDarkMode?Colors.white:Colors.black), // Light mode

      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontSize: 18,
          color: isDarkMode?Colors.white:Colors.black,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          fontSize: 12,//16
          color:isDarkMode?Colors.white:Colors.black,
          fontFamily: 'Poppins, sans-serif',
        ),

        bodySmall: TextStyle(
          fontSize: 14,
          color: isDarkMode?Colors.white:Colors.black,
          fontFamily: 'Poppins, sans-serif',
        ),
        headlineLarge: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold,
          color:isDarkMode?Colors.white:Colors.black,
          fontFamily: 'Poppins, sans-serif',
        ),
        headlineMedium: TextStyle(
          fontSize: 16,
          color: isDarkMode?Colors.white:Colors.black,
          fontFamily: 'Poppins, sans-serif',
          fontWeight: FontWeight.bold,
        ),
      ),
    );

  }

}