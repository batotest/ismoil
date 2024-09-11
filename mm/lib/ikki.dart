import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For DateFormat
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui'; // For BackdropFilter

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ikki(),
    );
  }
}

class ikki extends StatefulWidget {
  @override
  _ikkiState createState() => _ikkiState();
}

class _ikkiState extends State<ikki> {
  Map<String, String> names = {}; // Store names with timestamps
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNames();
  }

  Future<void> _loadNames() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      Map<String, String> loadedNames = {};
      List<String>? savedNames = prefs.getStringList('names');
      if (savedNames != null) {
        for (var name in savedNames) {
          var parts = name.split('|');
          if (parts.length == 2) {
            loadedNames[parts[0]] = parts[1];
          }
        }
      }
      names = loadedNames;
    });
  }

  Future<void> _saveNames() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedNames =
        names.entries.map((e) => '${e.key}|${e.value}').toList();
    await prefs.setStringList('names', savedNames);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddNameDialog,
          child: Icon(Icons.add),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/gul.jpg"), fit: BoxFit.cover)),
          child: ListView.builder(
            itemCount: names.length,
            itemBuilder: (context, index) {
              final name = names.keys.elementAt(index);
              final timestamp = names[name]!;
              return Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12.0),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$name (Qushilgan sana :',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        '$timestamp',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.black),
                        onPressed: () => _showEditNameDialog(name),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.black),
                        onPressed: () => _removeName(name),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  void _showAddNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: AlertDialog(
            backgroundColor: Colors.blue.withOpacity(0.5),
            title:
                Text('Add New Name', style: TextStyle(color: Colors.white)),
            content: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Enter name',
                labelStyle: TextStyle(color: Colors.black),
              ),
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  final newName = _nameController.text;
                  if (newName.isNotEmpty) {
                    DateTime now = DateTime.now();
                    String formattedDate =
                        DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(now);
                    setState(() {
                      names[newName] = formattedDate;
                      _nameController.clear();
                      _saveNames(); // Save the updated names
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Add', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditNameDialog(String oldName) {
    _nameController.text = oldName;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: AlertDialog(
              backgroundColor: Color(0xFF4A148C).withOpacity(0.9),
              title: Text('Edit Name', style: TextStyle(color: Colors.white)),
              content: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Enter new name',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    final newName = _nameController.text;
                    if (newName.isNotEmpty) {
                      DateTime now = DateTime.now();
                      String formattedDate =
                          DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(now);
                      setState(() {
                        names.remove(oldName);
                        names[newName] = formattedDate;
                        _nameController.clear();
                        _saveNames(); // Save the updated names
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeName(String name) {
    setState(() {
      names.remove(name);
      _saveNames(); // Save the updated names
    });
  }
}
