import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PriceScannerApp());
}

class PriceScannerApp extends StatelessWidget {
  const PriceScannerApp({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Price Scanner",
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
