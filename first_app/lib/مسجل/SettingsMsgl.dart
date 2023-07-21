// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:first_app/%D9%85%D8%B3%D8%AC%D9%84/add.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lottie/lottie.dart';

class SettingsMsgl extends StatefulWidget {
  SettingsMsgl({Key? key}) : super(key: key);

  @override
  State<SettingsMsgl> createState() => _SettingsMsglState();
}

class _SettingsMsglState extends State<SettingsMsgl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(144, 0, 173, 196),
          elevation: 5,
          centerTitle: true,
          title: Text(
            "الاعدادات",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          )),
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 500,
            width: 400,
            child: Lottie.network(
              'https://lottie.host/4c9dee5a-639f-48b6-87ee-dc9f0e26bf2b/gKpJuovWAC.json',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
          Column(
            children: [
              ClipPath(
                clipper: WaveClipperTwo(),
                child: Container(
                  height: 160,
                  color: Color.fromARGB(144, 0, 74, 83),
                  child: Center(child: Text("")),
                ),
              ),
              SizedBox(
                height: 326,
              ),
              ClipPath(
                clipper: WaveClipperTwo(reverse: true),
                child: Container(
                  height: 170,
                  color: Color.fromARGB(144, 0, 74, 83),
                  child: Center(child: Text("")),
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: Color.fromARGB(144, 0, 74, 83),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ZoomIn(
                  child: SizedBox(
                    height: 50,
                    width: 150,
                    child: Card(
                        elevation: 10,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(144, 1, 128, 142)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddItemScreen()));
                            },
                            child: Center(child: Icon(Icons.settings)))),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
