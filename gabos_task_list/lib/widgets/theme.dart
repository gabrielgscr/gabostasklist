import 'package:flutter/material.dart';
final ThemeData appTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Colors.grey[50],
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
  ),
  iconTheme: IconThemeData(
    color: strongBlue,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[200],
    // enabledBorder: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(10.0),
    //   borderSide: BorderSide(color: inactiveBorder, width: 2.0),
    // ),
    // focusedBorder: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(10.0),
    //   borderSide: BorderSide(color: strongBlue, width: 2.0),
    // ),
    // errorBorder: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(10.0),
    //   borderSide: BorderSide(color: errorBorder, width: 2.0),
    // ),
    // border: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(10.0),
    //   borderSide: BorderSide(color: strongBlue, width: 2.0),
    // ),
    border: InputBorder.none,
  )
);

var strongBlue = const Color(0xFF0D47A1);
var bottomNavigationBarBackgroundColor = Colors.blueGrey[50];
var inactiveBorder = Colors.blueGrey;
var errorBorder = Colors.red;
var taskTodo = Colors.green;
var overDueTask = Colors.red;
var defaultColor = Colors.black;
var defaultTextColor = Colors.white;
var defaultVSpace = const SizedBox(height: 10.0,);
var defaultBorderRadius = BorderRadius.circular(10.0);
var activeTrackColor = Colors.white;
var defaultPadding = const EdgeInsets.all(5.0);
var notesColor = Colors.yellow[100];
var lightRed = const Color(0xFFFFCCCC);
var lightGreen = const Color(0xFFAAFFAA);