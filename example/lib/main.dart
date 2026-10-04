import 'package:clipboard_history_example/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.white, fontSize: 20),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(backgroundColor: Colors.red),
        ),
        appBarTheme: AppBarThemeData(
          backgroundColor: Colors.indigo,
          centerTitle: true,
          titleTextStyle: Theme.of(context).textTheme.titleLarge,
        ),
        dividerTheme: DividerThemeData(
          thickness: 1,
          color: Color.fromARGB(255, 211, 210, 210),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
