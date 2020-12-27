import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preferences.init();
  runApp(FlappyApp());
}

class FlappyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}



