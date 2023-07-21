// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:lottie/lottie.dart';

class SearchByNumber extends StatefulWidget {
  @override
  _SearchByNumberState createState() => _SearchByNumberState();
}

class _SearchByNumberState extends State<SearchByNumber> {
  String name = "";
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  void getDate() async {
    final snapshot =
        await FirebaseFirestore.instance.collection("Dammam").get();

    snapshot.docs.forEach((doc) {
      print(doc.data()["الاسم"]);
    });
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }

  bool containsArabicNumber(String text) {
    final arabicNumbersRegex =
        RegExp(r'[\u0660-\u0669]'); // Matches Arabic numbers from ٠ to ٩
    return arabicNumbersRegex.hasMatch(text);
  }

  bool isEquivalentArabicCharacter(String a, String b) {
    final arabicNumbersMap = {
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

    if (a == b) {
      return true;
    }

    if (arabicNumbersMap.containsKey(a)) {
      return arabicNumbersMap[a] == b;
    } else if (arabicNumbersMap.containsKey(b)) {
      return arabicNumbersMap[b] == a;
    }

    return false;
  }

  bool isEquivalentArabicText(String text1, String text2) {
    if (text1.length != text2.length) {
      return false;
    }

    for (int i = 0; i < text1.length; i++) {
      final char1 = text1[i];
      final char2 = text2[i];

      if (!isEquivalentArabicCharacter(char1, char2)) {
        return false;
      }
    }

    return true;
  }

  List<String> getEquivalentArabicTexts(String text) {
    final arabicNumbersMap = {
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

    final equivalentTexts = <String>[];
    final digits = text.split('');

    for (final digit in digits) {
      if (arabicNumbersMap.containsKey(digit)) {
        final equivalentDigit = arabicNumbersMap[digit];
        final currentEquivalentTexts = <String>[];

        if (equivalentTexts.isEmpty) {
          currentEquivalentTexts.add(digit);
          currentEquivalentTexts.add(equivalentDigit!);
        } else {
          for (final text in equivalentTexts) {
            currentEquivalentTexts.add(text + digit);
            currentEquivalentTexts.add(text + equivalentDigit!);
          }
        }

        equivalentTexts.clear();
        equivalentTexts.addAll(currentEquivalentTexts);
      } else {
        if (equivalentTexts.isEmpty) {
          equivalentTexts.add(digit);
        } else {
          for (final text in equivalentTexts) {
            equivalentTexts.add(text + digit);
          }
        }
      }
    }

    return equivalentTexts;
  }

  List<String> getSearchKeywords(String searchInput) {
    final keywords = <String>[];
    final inputLowercase = searchInput.toLowerCase();

    if (containsArabicNumber(inputLowercase)) {
      keywords.add(inputLowercase);
      keywords.addAll(getEquivalentArabicTexts(inputLowercase));
    } else {
      keywords.add(inputLowercase);
    }

    return keywords;
  }

  bool doesDocumentMatchSearch(DocumentSnapshot document, String searchInput) {
    final keywords = getSearchKeywords(searchInput);

    for (final keyword in keywords) {
      final name = document['الاسم'].toString().toLowerCase();
      final code = document['الرمز'].toString().toLowerCase();

      if (name.contains(keyword) || code.contains(keyword)) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(144, 0, 173, 196),
        title: Card(
          elevation: 10,
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "البحث",
            ),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: 200,
            width: 200,
          ),
          Container(
            height: 500,
            width: 400,
            child: Lottie.network(
              'https://lottie.host/1b84fe20-f5f8-4ecf-95c7-959cc58286f4/Ze8rQrkLkb.json',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            width: double.infinity,
            color: Color.fromARGB(144, 0, 74, 83),
            height: MediaQuery.of(context).size.height,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Dammam").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final searchData = snapshot.data!.docs.where((doc) {
                return doesDocumentMatchSearch(doc, name);
              }).toList();

              return ListView.builder(
                itemCount: searchData.length,
                itemBuilder: (context, index) {
                  var data = searchData[index];
                  return ListTile(
                      leading: Icon(
                        Icons.location_city,
                        size: 45,
                      ),
                      title: Text(
                        data["الاسم"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        data["الرمز"],
                        style: TextStyle(fontSize: 15),
                      ),
                      trailing: Text(data["المكتب"],
                          style: TextStyle(fontWeight: FontWeight.bold)));
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget float1() {
    return Container(
      child: FloatingActionButton(
        onPressed: null,
        heroTag: "btn1",
        elevation: 10,
        backgroundColor: Colors.grey,
        tooltip: 'First button',
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget float2() {
    return Container(
      child: FloatingActionButton(
        onPressed: null,
        elevation: 10,
        heroTag: "btn2",
        backgroundColor: Colors.green,
        tooltip: 'Second button',
        child: Icon(Icons.add),
      ),
    );
  }
}
