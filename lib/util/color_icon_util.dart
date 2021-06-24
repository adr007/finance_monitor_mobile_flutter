import 'dart:ui';

import 'package:flutter/material.dart';

class ColorIconUtil {
  static IconData getIcon(String nameIcon) {
    switch(nameIcon) {
      case 'layers':
        return Icons.layers;
      case 'lock_outline_sharp':
        return Icons.lock_outline_sharp;
      case 'business_center_sharp':
        return Icons.business_center_sharp;
      case 'attach_money':
        return Icons.attach_money;
      default:
        return Icons.apps_rounded;
    }
  }

  static Color getColor(String nameColor) {
    switch(nameColor) {
      case 'lightBlue':
        return Colors.lightBlue;
      case 'amber':
        return Colors.amber;
      case 'teal':
        return Colors.teal;
      case 'green':
        return Colors.green;
      default:
        return Colors.amberAccent;
    }
  }
}