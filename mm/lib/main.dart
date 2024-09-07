import 'package:flutter/material.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mm/besh.dart';
import 'package:mm/bir.dart';
import 'package:mm/ikki.dart';
import 'package:mm/tort.dart';
import 'package:mm/uch.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: kkkk(),
  ));
}

class kkkk extends StatefulWidget {
  const kkkk({super.key});

  @override
  State<kkkk> createState() => _kkkkState();
}

class _kkkkState extends State<kkkk> {
  bool isDarkMode = false;
  bool isLoading = true;
  int select = 0;
  List nav = [bir(), ikki(), uch(), tort(), besh()];
  void kol(i) {
    setState(() {
      select = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.blue,
        color: Colors.blue,
        items: [
          Icon(Icons.book),
          Icon(Icons.hourglass_empty_sharp),
          Icon(Icons.add),
          Icon(Icons.signal_wifi_connected_no_internet_4_sharp),
          Icon(Icons.photo_library),
        ],
        onTap: kol,
      ),
      body: nav.elementAt(select),
    );
  }
}
