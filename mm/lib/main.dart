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

class _kkkkState extends State<kkkk> with SingleTickerProviderStateMixin {
  bool isDarkMode = false;
  int select = 0; // Selected index
  List nav = [bir(), ikki(), uch(), tort(), besh()];

  // Animation Controller
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 05),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void kol(int i) {
    setState(() {
      select = i; // Update the selected index
    });

    // Reset and start animation for the selected icon
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        buttonBackgroundColor: Color.fromARGB(255, 0, 4, 119),
        color: Color.fromARGB(255, 14, 0, 172),
        items: [
          _buildRotatingIcon(Icons.home, isSelected: select == 0),
          _buildRotatingIcon(Icons.hourglass_empty_sharp,
              isSelected: select == 1),
          _buildRotatingIcon(Icons.add, isSelected: select == 2),
          _buildRotatingIcon(Icons.signal_wifi_connected_no_internet_4_sharp,
              isSelected: select == 3),
          _buildRotatingIcon(Icons.photo_library, isSelected: select == 4),
        ],
        onTap: kol,
      ),
      body: nav.elementAt(select),
    );
  }

  // Helper function to build rotating icons with horizontal flip
  Widget _buildRotatingIcon(IconData icon, {bool isSelected = true}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Rotate only the selected icon
        final rotationValue =
            isSelected ? _controller.value * 5.toDouble() * 3.14159 : 0.0;
        return Transform(
          transform: Matrix4.identity()
            ..rotateY(rotationValue), // Rotate only when selected
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white), // Customize the icon style
        );
      },
    );
  }
}
