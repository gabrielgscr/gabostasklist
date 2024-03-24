import 'package:flutter/material.dart';
import 'package:gabos_task_list/widgets/theme.dart';

class InputDecorations {
  static InputDecoration defaultInputDecoration(
      {required String hintText,
      required String labelText,
      IconData? prefixIcon, bool? filled = true, 
      Color? fillColor = Colors.white, 
      }) {
    return InputDecoration(
      isDense: true,
        filled: filled,
        fillColor: fillColor,
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: strongBlue)
            : null);
  }
}
