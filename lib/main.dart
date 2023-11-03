import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'Screens/home_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('to_do Hive');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primarySwatch: Colors.yellow
    ),
    home: HomePage(),
  ));
}
