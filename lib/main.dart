import 'package:flutter/material.dart';
import 'calendar_page.dart';
import 'select_group_page.dart';

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
      routes: <String, WidgetBuilder>{
        '/config': (BuildContext ctx) => const SelectGroupPage()
      },
      home: Scaffold(
          appBar: AppBar(title: const Text("IU Schedule")),
          body: const SafeArea(child: CalendarPage())),
    );
  }
}
