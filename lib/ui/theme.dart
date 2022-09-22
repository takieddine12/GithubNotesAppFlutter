
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../misc/app_colors.dart';

class Themes {

  static final light = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: AppColors.primaryColor,
    brightness: Brightness.light
  );

  static final dark = ThemeData(
    backgroundColor: AppColors.darkGreyColor,
    primaryColor: AppColors.darkGreyColor,
    brightness: Brightness.dark
  );


}

TextStyle get subHeaderStyle{
  return GoogleFonts.lato(
      textStyle:  TextStyle(fontSize: 17,fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.grey[400] : Colors.grey)
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(fontSize : 30 ,fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.white : Colors.black)
  );
}