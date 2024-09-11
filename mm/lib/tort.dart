import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: tort(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Yil Tugashiga Qolgan Vaqt')),
        body: Center(
          child: tort(),
        ),
      ),
    );
  }
}

class tort extends StatefulWidget {
  @override
  _tortState createState() => _tortState();
}

class _tortState extends State<tort> {
  late DateTime endOfYear;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    endOfYear = DateTime(DateTime.now().year, 12, 31, 23, 59, 59);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {}); // Trigger a rebuild every second
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final timeRemaining = endOfYear.difference(currentDate);

    final daysRemaining = timeRemaining.inDays;
    final hoursRemaining = timeRemaining.inHours % 24;
    final minutesRemaining = (timeRemaining.inMinutes % 60);
    final secondsRemaining = (timeRemaining.inSeconds % 60);

    final formattedDate = DateTime(
      1970,
      1,
      1,
      hoursRemaining,
      minutesRemaining,
      secondsRemaining,
    );

    final dateFormat = DateFormat('HH');
    final dateFormat2 = DateFormat('mm');
    final dateFormat3 = DateFormat('ss');
    final timeString = dateFormat.format(formattedDate);
    final timeString2 = dateFormat2.format(formattedDate);
    final timeString3 = dateFormat3.format(formattedDate);

    return Padding(
      padding: const EdgeInsets.only(top: 300),
      child: Center(
        child: Column(
          children: [
            Text(
              'Yil tugashiga qolgan vaqt:',
              style: TextStyle(fontSize: 20),
            ),
            Container(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$daysRemaining kun',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '$timeString soat',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '$timeString2 daqiqa',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '$timeString3 sekund',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
