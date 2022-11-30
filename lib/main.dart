// ! Created By DZ-TM071 Free Open Source Code !
import 'package:flutter/material.dart';
import 'package:proyectofinal/Pages/home.dart';
import 'Pages/operation.dart';
import 'Pages/user.dart';

void main() {
  runApp(TinderClone(products: fetchUsers()));
}

class TinderClone extends StatelessWidget {
  // This widget is the root of your application.
  final Future<List<User>> products;
  TinderClone({required this.products});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
      ),
      home: Home(products: products),
    );
  }
}