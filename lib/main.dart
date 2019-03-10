import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'myHomePage.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(new MyApp());
    });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      routes: {
        '/': (BuildContext context) => MyHomePage(),
        
      },
    );
  }
}







