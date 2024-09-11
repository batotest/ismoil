import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: ikkki(),
  ));
}

class ikkki extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: uch(),
    );
  }
}

class uch extends StatefulWidget {
  @override
  _uchState createState() => _uchState();
}

class _uchState extends State<uch> {
  String usdRate = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadDollarRate();
  }

  Future<void> _loadDollarRate() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedRate = prefs.getString('usdRate');
    
    if (savedRate != null) {
      setState(() {
        usdRate = savedRate;
      });
    } else {
      await fetchDollarRate();
    }
  }

  Future<void> fetchDollarRate() async {
    var url = Uri.parse('https://cbu.uz/uz/arkhiv-kursov-valyut/json/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      for (var currency in data) {
        if (currency['Ccy'] == 'USD') {
          setState(() {
            usdRate = currency['Rate'];
          });
          // Save the rate to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('usdRate', usdRate);
          return;
        }
      }
    } else {
      setState(() {
        usdRate = 'Failed to fetch rate';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "kurs: $usdRate UZS",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i = 1; i <= 50; i++) // 50 qatorli archa yasash
                  Text(
                   "" * (10 - i) +
                        'X' * (1 * i - 0), // X dan archa yaratish formulasi
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
