
import 'package:flutter/material.dart';

import '../misc/app_colors.dart';

class Themes {

  static final light = ThemeData(
    primaryColor: AppColors.primaryColor,
    brightness: Brightness.light
  );

  static final dark = ThemeData(
    primaryColor: AppColors.darkGreyColor,
    brightness: Brightness.dark
  );
}