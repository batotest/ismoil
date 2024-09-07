import 'package:flutter/material.dart';

void main() {
  runApp(TasbihApp());
}

class TasbihApp extends StatelessWidget {
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
  int _counter = 0;

  // Function to increment the counter
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Function to show the reset confirmation dialog in Uzbek
  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tasdiqlash'),
          content: Text('Hisoblagichni noldan boshlashni xohlaysizmi?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yo\'q'),
            ),
            TextButton(
              onPressed: () {
                _resetCounter();
                Navigator.of(context).pop(); // Close the dialog after resetting
              },
              child: Text('Ha'),
            ),
          ],
        );
      },
    );
  }

  // Function to reset the counter
  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/tasbeh3.jpg"), fit: BoxFit.cover)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_counter',
              style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: _showResetDialog, // Call dialog function on reset button
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Color.fromARGB(255, 0, 184, 0),
                    child: CircleAvatar(
                      radius: 25,
                      child: Text(
                        'RESET',
                        style: TextStyle(color: Colors.green, fontSize: 15),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                InkWell(
                  onTap: _incrementCounter,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Color.fromARGB(255, 0, 184, 0),
                    child: CircleAvatar(
                      radius: 45,
                      child: Text(
                        'COUNT',
                        style: TextStyle(color: Colors.green, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
