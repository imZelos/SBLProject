import 'package:first_app/%D9%85%D8%B3%D8%AC%D9%84/SearchByNumber.dart';
import 'package:first_app/%D9%85%D8%B3%D8%AC%D9%84/msgl.dart';
import 'package:first_app/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the rootd of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(routes: {
      "msg": (context) => msgl(),
      "HomePage": ((context) => HomePage()),
      "SearchByNumber": ((context) => SearchByNumber())
    }, debugShowCheckedModeBanner: false, home: HomePage());
  }
}
