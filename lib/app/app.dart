import 'package:flutter/material.dart';

import '../home/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Color.fromARGB(255, 237, 88, 19),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
