import 'package:flutter/material.dart';
import 'Screen/MyBottomNavigationBar.dart';
import 'Screen/HomePage.dart';
import 'Screen/User.dart';
import 'Screen/Offers.dart';
import 'Screen/Cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Firebase Login",
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      debugShowCheckedModeBanner: false,
      home: MyBottomNavigationBar(),
    );
  }
}
