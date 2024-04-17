import 'package:flutter/material.dart';
import 'package:bmi_calculator/pages/home.dart';
import 'package:bmi_calculator/pages/DGE.dart';
import 'package:bmi_calculator/pages/settings.dart';


void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context)=>Home(),
      '/settings':(context)=>Settings(),
      '/dge':(context)=>DGE(),
    },
  ));
}
