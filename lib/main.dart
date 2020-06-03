import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'Mapping.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home:Mapping(auth:Auth()),
    );
  }
}
