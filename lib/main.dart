import 'package:checkin/screens/index_page.dart';
import 'package:flutter/material.dart';


void main() async {
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
      //  theme: ThemeData(),
    // darkTheme: ThemeData.dark(),
    themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
        primaryColor: Colors.white,
        hintColor: Colors.red,
        textTheme: const TextTheme(
          bodyText1: TextStyle(fontSize: 16.0),
        ),
      ),
        darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color.fromARGB(255, 60, 59, 59),
        hintColor: Colors.white,
        textTheme: const TextTheme(
          bodyText1: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
      title: 'Checkin',
      home: const IndexPage(),
    );
  }
}
  