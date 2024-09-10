import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: bir(),
    );
  }
}

class bir extends StatefulWidget {
  @override
  _birState createState() => _birState();
}

class _birState extends State<bir> {
  List<String> _names = []; // Bir nechta ism saqlash uchun ro'yxat
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNames(); // Dastur ishga tushganda saqlangan ismlarni yuklash
  }

  // Ismlarni saqlash
  Future<void> _saveNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedNames', _names);
  }

  // Saqlangan ismlarni yuklash
  Future<void> _loadNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _names = prefs.getStringList('savedNames') ?? []; // Saqlangan ismlar ro'yxatini yuklash
    });
  }

  // Dialog orqali ism olish
  void _showNameInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ismingizni kiriting"),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: "Ism kiriting",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialogni yopish
              },
              child: Text("Bekor qilish"),
            ),
            ElevatedButton(
              onPressed: () {
                String enteredName = _nameController.text;
                if (enteredName.isNotEmpty) {
                  setState(() {
                    _names.add(enteredName); // Ismni ro'yxatga qo'shish
                  });
                  _saveNames(); // Yangilangan ismlar ro'yxatini saqlash
                }
                _nameController.clear(); // TextField-ni tozalash
                Navigator.of(context).pop(); // Dialogni yopish
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ismni kiritish"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _names.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _names[index], // Ro'yxatdagi ismni ko'rsatish
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _showNameInputDialog, // Dialogni ochish
              iconSize: 40,
            ),
          ],
        ),
      ),
    );
  }
}
