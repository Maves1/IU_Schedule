import 'package:flutter/material.dart';
import 'calendar_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IU Schedule',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
          appBar: AppBar(title: const Text("IU Schedule")),
          body: const SafeArea(child: CalendarPage())),
    );
  }
}
