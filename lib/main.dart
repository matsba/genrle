import 'package:flutter/material.dart';
import 'package:genreguesser/home.dart';
import 'package:genreguesser/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genrle',
      theme: GlobalTheme().globalTheme,
      home: HomePage(),
    );
  }
}
