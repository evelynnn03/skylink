import 'package:flutter/material.dart';

class Variables {
  static const primaryColor = Color.fromARGB(255, 131, 175, 217);
  static const textLabel = Color.fromARGB(255, 190, 190, 190);
  static const greyBG = Color.fromARGB(255, 226, 226, 226);
  static const bottomNavIcons = Color(0xFFD0E4FF);
  static const bottomNavSelectedIcons = Color(0xFFF7F2EC);

  // Responsive Text Styles
  static double responsiveFontSize(BuildContext context, double fontSize) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 380) {
      return fontSize * 0.8;
    } else if (screenWidth < 450) {
      return fontSize * 0.9;
    }
    return fontSize;
  }

  // Text field label style
  static TextStyle hintStyle(BuildContext context) => TextStyle(
        color: textLabel,
        fontSize: responsiveFontSize(context, 18.0),
        fontWeight: FontWeight.bold,
      );

  // Bottom Nav Bar selected text
  static TextStyle selectedBottomNavStyle(BuildContext context) => TextStyle(
        fontSize: responsiveFontSize(context, 14.0),
        fontWeight: FontWeight.bold,
      );

  // Bottom Nav Bar unselected text
  static double unselectedBottomNavStyle(BuildContext context) {
    return responsiveFontSize(context, 13.0);
  }

  // Icon style
  // Responsive Icon Size
  static double responsiveIconSize(BuildContext context, double iconSize) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 380) {
      return iconSize * 0.8;
    } else if (screenWidth < 450) {
      return iconSize * 0.9;
    }
    return iconSize; // default icon size
  }

  // Back Button
  static IconButton backButton(BuildContext context, {Color? color}) =>
      IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: color ?? Colors.black,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
}
