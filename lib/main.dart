import 'package:flutter/material.dart';
import 'package:max_walls/pages/home_screen.dart';
 
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.grey,
        ),
        // Set to dark mode

        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
