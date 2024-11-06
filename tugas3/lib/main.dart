import 'package:flutter/material.dart';
import 'package:tugas3/views/list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Lists',
      theme: ThemeData(
       
        useMaterial3: true,
      ),
      home: const AnimeListScreen(),
    );
  }
}
