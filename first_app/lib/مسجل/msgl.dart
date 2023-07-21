// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:first_app/%D9%85%D8%B3%D8%AC%D9%84/SearchByNumber.dart';
import 'package:first_app/%D9%85%D8%B3%D8%AC%D9%84/SettingsMsgl.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class msgl extends StatefulWidget {
  @override
  State<msgl> createState() => _msglState();
}

const _heightPercentages = [
  0.65,
  1.6,
];

const _durations = [
  5000,
  4000,
];
const _colors = [Color.fromARGB(144, 2, 46, 52), Color.fromARGB(144, 0, 0, 0)];
const _backgroundColor = Color.fromARGB(144, 0, 173, 196);

class _msglState extends State<msgl> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(144, 0, 173, 196),
          elevation: 5,
          centerTitle: true,
          title: Text(
            "المسجل",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          )),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              ClipPath(
                clipper: WaveClipperTwo(),
                child: Container(
                  height: 180,
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
                        elevation: 35,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(144, 1, 128, 142)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchByNumber()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 40,
                                )
                              ],
                            )),
                      )),
                ),
                ZoomIn(
                  child: SizedBox(
                      height: 50,
                      width: 150,
                      child: Card(
                        elevation: 35,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(144, 1, 128, 142)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingsMsgl()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.settings,
                                  size: 35,
                                )
                              ],
                            )),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
