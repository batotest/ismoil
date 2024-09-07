import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ikki extends StatefulWidget {
  @override
  _ikkiState createState() => _ikkiState();
}

class _ikkiState extends State<ikki> {
  TextEditingController locationController = TextEditingController();
  Map<String, dynamic>? prayerTimes;
  bool isLoading = false;

  // Function to fetch prayer times based on location
  Future<void> fetchPrayerTimes(String location) async {
    setState(() {
      isLoading = true; // Show loading while fetching data
    });

    final url = 'https://api.aladhan.com/v1/timingsByAddress?address=$location';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          prayerTimes = jsonData['data']['timings'];
        });
      } else {
        print("Failed to fetch data");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false; // Hide loading after fetching data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Prayer Times'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField to input city or country name
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter city or country',
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  fetchPrayerTimes(
                      value); // Fetch prayer times for input location
                }
              },
            ),
            SizedBox(height: 20),

            // Show loading indicator while fetching data
            if (isLoading) CircularProgressIndicator(),

            // Display fetched prayer times
            if (prayerTimes != null && !isLoading)
              Expanded(
                child: ListView(
                  children: prayerTimes!.entries.map((entry) {
                    return ListTile(
                      title: Text("${entry.key}: ${entry.value}"),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
