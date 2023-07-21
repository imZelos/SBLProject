import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'مسجل/msgl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

const _heightPercentages = [
  0.65,
  1.6,
];

const _durations = [
  5000,
  4000,
];

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    const _colors = [
      Color.fromARGB(144, 2, 46, 52),
      Color.fromARGB(144, 0, 0, 0)
    ];
    const _backgroundColor = Color.fromARGB(144, 0, 173, 196);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
              backgroundColor: Color.fromARGB(144, 0, 173, 196),
              elevation: 5,
              leading: Image(
                  image: NetworkImage(
                      "https://play-lh.googleusercontent.com/8kr09tJYhwD6l-zpkuEkdBzHAVc7dHdb3G7iBvRBSA4EjaSA1cO-WyVbwlpm-Csf-wAk")),
              centerTitle: true,
              title: Text(
                "الرئيسية",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
          body: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Column(
                children: [],
              ),
              WaveWidget(
                config: CustomConfig(
                  colors: _colors,
                  durations: _durations,
                  heightPercentages: _heightPercentages,
                ),
                backgroundColor: _backgroundColor,
                size: Size(double.infinity, double.infinity),
                waveAmplitude: 0,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Color.fromARGB(144, 0, 74, 83),
              ),
              Container(
                  height: 350,
                  width: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BounceInDown(
                        child: SizedBox(
                            height: 50,
                            width: 350,
                            child: Card(
                              elevation: 35,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:
                                          Color.fromARGB(144, 1, 128, 142)),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => msgl()));
                                  },
                                  child: Text(
                                    "المسجل",
                                    style: TextStyle(fontSize: 25),
                                  )),
                            )),
                      ),
                      BounceInDown(
                        child: SizedBox(
                            height: 50,
                            width: 350,
                            child: Card(
                              elevation: 35,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:
                                          Color.fromARGB(144, 1, 128, 142)),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => msgl()));
                                  },
                                  child: Text(
                                    "الممتاز",
                                    style: TextStyle(fontSize: 25),
                                  )),
                            )),
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }
}
