// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:note_taking_app/screens/welcome_screen.dart';
import 'package:sqflite/sqflite.dart'; // Standard sqflite package for mobile
// import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // For desktop

void main() {
  // Initialize FFI only for desktop platforms
  // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //   sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7E7DC), // Global background
      ),
      home: const NoteTakingApp(),
    );
  }
}
