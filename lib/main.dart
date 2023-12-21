import 'package:flutter/material.dart';
import 'package:note_keeper_app/screens/note_detail_screen.dart';
import 'package:note_keeper_app/screens/note_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const NoteDetailScreen(),
    );
  }
}
