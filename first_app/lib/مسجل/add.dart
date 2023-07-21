// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _code = '';
  String _location = '';

  CollectionReference dammamRef =
      FirebaseFirestore.instance.collection("Dammam");

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String normalizedCode = _normalizeArabic(_code);

      checkFieldsNotDuplicated(_name, normalizedCode, _location)
          .then((isNotDuplicated) {
        if (isNotDuplicated) {
          // No duplicates found, safe to add the item
          dammamRef.add({
            'الاسم': _name,
            'الرمز': normalizedCode,
            'المكتب': _location,
          }).then((_) {
            print('تمت الاضافة بنجاح!');
            _showNotification(context, 'تمت الاضافة بنجاح', Colors.green);
          }).catchError((error) {
            print('حدث خطأ: $error');
          });
        } else {
          // Duplicates found

          print('تمت اضافة الحي من قبل');
          _showNotification(context, 'تمت اضافة الحي من قبل', Colors.red);
        }
      }).catchError((error) {
        print('حدث خطأ: $error');
      });
    }
  }

  void _deleteItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String normalizedCode = _normalizeArabic(_code);

      checkFieldsExist(_name, normalizedCode, _location).then((exists) {
        if (exists) {
          // Item exists, show confirmation dialog before deleting
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('تأكيد الحذف'),
                content: const Text('هل أنت متأكد أنك تريد حذف هذا العنصر؟'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('إلغاء'),
                  ),
                  TextButton(
                    onPressed: () {
                      _performDelete(); // Delete the item
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('حذف'),
                  ),
                ],
              );
            },
          );
        } else {
          // Item not found
          print('العنصر غير موجود');
          _showNotification(context, 'العنصر غير موجود', Colors.red);
        }
      }).catchError((error) {
        print('حدث خطأ: $error');
      });
    }
  }

  Future<void> _performDelete() async {
    // Perform the actual deletion
    String normalizedCode = _normalizeArabic(_code);

    QuerySnapshot snapshot = await dammamRef
        .where('الاسم', isEqualTo: _name)
        .where('الرمز', isEqualTo: normalizedCode)
        .where('المكتب', isEqualTo: _location)
        .get();

    if (snapshot.docs.isNotEmpty) {
      snapshot.docs.first.reference.delete().then((_) {
        print('تم الحذف بنجاح!');
        _showNotification(context, 'تم الحذف بنجاح', Colors.green);
      }).catchError((error) {
        print('حدث خطأ: $error');
      });
    }
  }

  Future<bool> checkFieldsNotDuplicated(
      String name, String code, String location) async {
    QuerySnapshot snapshot =
        await dammamRef.where('الرمز', isEqualTo: code).get();

    if (snapshot.docs.isNotEmpty) {
      return false; // Duplicated code found
    }

    snapshot = await dammamRef
        .where('الاسم', isEqualTo: name)
        .where('المكتب', isEqualTo: location)
        .get();

    return snapshot
        .docs.isEmpty; // Returns true if no duplicates found, false otherwise
  }

  Future<bool> checkFieldsExist(
      String name, String code, String location) async {
    QuerySnapshot snapshot = await dammamRef
        .where('الاسم', isEqualTo: name)
        .where('الرمز', isEqualTo: code)
        .where('المكتب', isEqualTo: location)
        .get();

    return snapshot
        .docs.isNotEmpty; // Returns true if item exists, false otherwise
  }

  String _normalizeArabic(String input) {
    Map<String, String> arabicToEnglish = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };

    String normalizedCode = '';
    for (int i = 0; i < input.length; i++) {
      String char = input[i];
      if (arabicToEnglish.containsKey(char)) {
        normalizedCode += arabicToEnglish[char]!;
      } else {
        normalizedCode += char;
      }
    }
    return normalizedCode;
  }

  Color nameColor = Colors.black;
  void _showNotification(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const _colors = [
      Color.fromARGB(144, 2, 46, 52),
      Color.fromARGB(144, 0, 0, 0)
    ];
    const _durations = [
      5000,
      4000,
    ];
    const _heightPercentages = [
      0.55,
      10.6,
    ];
    const _backgroundColor = Color.fromARGB(144, 200, 200, 200);
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: const Color.fromARGB(144, 0, 173, 196),
        centerTitle: true,
        title: const Text(
          'البيانات',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25),
        ),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationX(
                      3.1415926535897932), // Flipping around the X-axis (180 degrees)
                  child: WaveWidget(
                    config: CustomConfig(
                      colors: _colors,
                      durations: _durations,
                      heightPercentages: _heightPercentages,
                    ),
                    backgroundColor: _backgroundColor,
                    size: Size(double.infinity, double.infinity),
                    waveAmplitude: 0,
                  ),
                ),
              ),
              Column(
                children: [
                  ClipPath(
                    clipper: WaveClipperTwo(),
                    child: Container(
                      height: 340,
                      color: Color.fromARGB(144, 6, 148, 167),
                      child: Center(child: Text("")),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ClipPath(
                    clipper: WaveClipperTwo(reverse: true),
                    child: Container(
                      height: 280,
                      color: Color.fromARGB(144, 0, 74, 83),
                      child: Center(child: Text("")),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                        width: 700,
                        child: TextFormField(
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            label: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "الاسم",
                                  style: TextStyle(color: nameColor),
                                )
                              ],
                            ),
                            labelStyle: TextStyle(fontSize: 15),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'ادخال الاسم';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _name = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label: Row(
                            children: [
                              Icon(
                                Icons.numbers,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "الرمز",
                                style: TextStyle(color: nameColor),
                              )
                            ],
                          ),
                          labelStyle: TextStyle(fontSize: 15),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرمز البريدي';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _code = value!;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'المكتب',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SizedBox(
                                height: 35,
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _location = 'الاتصالات';
                                    });
                                  },
                                  child: Text(
                                    'الاتصالات',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    backgroundColor: _location == 'الاتصالات'
                                        ? const Color.fromARGB(144, 0, 173, 196)
                                        : Colors.white,
                                    elevation: 8,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SizedBox(
                                height: 35,
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _location = 'الندى';
                                    });
                                  },
                                  child: Text(
                                    'الندى',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      backgroundColor: _location == 'الندى'
                                          ? const Color.fromARGB(
                                              144, 0, 173, 196)
                                          : Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Card(
                                elevation: 10,
                                child: SizedBox(
                                  height: 35,
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _location = 'النور';
                                      });
                                    },
                                    child: Text(
                                      'النور',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _location == 'النور'
                                          ? Color.fromARGB(255, 49, 167, 53)
                                          : const Color.fromARGB(
                                              144, 0, 173, 196),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Card(
                                elevation: 10,
                                child: SizedBox(
                                  height: 35,
                                  width: 115,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _location = 'المكتب الرئيسي';
                                      });
                                    },
                                    child: Text(
                                      'المكتب الرئيسي',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _location == 'المكتب الرئيسي'
                                              ? Color.fromARGB(255, 49, 167, 53)
                                              : const Color.fromARGB(
                                                  144, 0, 173, 196),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Card(
                                elevation: 10,
                                child: SizedBox(
                                  height: 35,
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _location = 'الزهور';
                                      });
                                    },
                                    child: Text(
                                      'الزهور',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _location == 'الزهور'
                                          ? Color.fromARGB(255, 49, 167, 53)
                                          : const Color.fromARGB(
                                              144, 0, 173, 196),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Card(
                                elevation: 10,
                                child: SizedBox(
                                  height: 35,
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _location = 'الشاطئ';
                                      });
                                    },
                                    child: Text(
                                      'الشاطئ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _location == 'الشاطئ'
                                          ? Color.fromARGB(255, 49, 167, 53)
                                          : const Color.fromARGB(
                                              144, 0, 173, 196),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Card(
                                elevation: 10,
                                child: SizedBox(
                                  height: 35,
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _location = 'عبدالله فؤاد';
                                      });
                                    },
                                    child: Text(
                                      'عبدالله فؤاد',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _location == 'عبدالله فؤاد'
                                              ? Color.fromARGB(255, 49, 167, 53)
                                              : const Color.fromARGB(
                                                  144, 0, 173, 196),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                      Card(
                        elevation: 10,
                        child: SizedBox(
                          height: 40,
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: _submitForm,
                            child: Text(
                              'اضافة',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Card(
                        elevation: 10,
                        child: SizedBox(
                          height: 40,
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent),
                            onPressed: _deleteItem,
                            child: Text(
                              'حذف',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
