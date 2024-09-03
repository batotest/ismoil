import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> _filteredItems = [];

  final List<String> _items = [
    "Apple",
    "ganana",
    "Cherry",
    "Date",
    "Elderberry",
    "Fig",
    "Grape",
    "Honeydew",
    "Kiwi",
    "Lemon",
    "Mango",
    "Mectarine",
    "Orange",
    "Papaya",
    "Quince",
    "Raspberry",
    "Strawberry",
    "Tomato",
    "Ugli fruit",
    "Vanilla",
    "Watermelon",
    "Xigua",
    "Yellow Passion Fruit",
    "Zucchini"
  ];

  void _performSearch(String query) {
    setState(() {
      _filteredItems = _items
          .where((item) => item.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Search App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'Search for an item...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _filteredItems.isEmpty
                  ? Text(
                      'No items found',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    )
                  : ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_filteredItems[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}