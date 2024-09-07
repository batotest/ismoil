import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class bir extends StatefulWidget {
  @override
  _birState createState() => _birState();
}

class _birState extends State<bir> {
  List<Map<String, dynamic>> surahList = [];
  bool isDarkMode = false;
  bool isLoading = true; // Track loading state

  // Fetch data in parallel using Future.wait for faster loading
  void fetchData() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      // Run both requests in parallel
      final responses = await Future.wait([
        http.get(Uri.parse("https://api.alquran.cloud/v1/quran/uz.sodik")),
        http.get(Uri.parse("https://api.alquran.cloud/v1/quran/ar.alafasy")),
      ]);

      final responseUzbek = responses[0];
      final responseArabic = responses[1];

      if (responseUzbek.statusCode == 200 && responseArabic.statusCode == 200) {
        final jsonDataUzbek = json.decode(responseUzbek.body);
        final jsonDataArabic = json.decode(responseArabic.body);

        if (jsonDataUzbek != null && jsonDataArabic != null) {
          List<dynamic> surahsUzbek = jsonDataUzbek['data']['surahs'];
          List<dynamic> surahsArabic = jsonDataArabic['data']['surahs'];

          for (int i = 0; i < surahsUzbek.length; i++) {
            List<Map<String, dynamic>> ayahs = [];
            for (int j = 0; j < surahsUzbek[i]['ayahs'].length; j++) {
              ayahs.add({
                "text": surahsUzbek[i]['ayahs'][j]['text'],
                "text_ar": surahsArabic[i]['ayahs'][j]['text'],
              });
            }

            surahList.add({
              "number": surahsUzbek[i]['number'],
              "name": surahsUzbek[i]['name'],
              "englishName": surahsUzbek[i]['englishName'],
              "ayahs": ayahs,
            });
          }

          setState(() {
            isLoading = false; // Data has been loaded, hide loading indicator
          });
        }
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      setState(() {
        isLoading = false; // On error, stop loading
      });
      print("Error: $e");
    }
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        title: Text(
          'Qur\'on Suralari (O\'zbek)',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: toggleTheme,
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          : ListView.builder(
              itemCount: surahList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    "${surahList[index]['number']}",
                    style: TextStyle(
                      fontSize: 18,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  title: Text(
                    "${surahList[index]['englishName']} (${surahList[index]['name']})",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Nol(
                          surahList[index],
                          isDarkMode: isDarkMode,
                          toggleTheme: toggleTheme,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class Nol extends StatefulWidget {
  final Map<String, dynamic> surah;
  final bool isDarkMode;
  final Function toggleTheme;

  Nol(this.surah, {required this.isDarkMode, required this.toggleTheme});

  @override
  _NolState createState() => _NolState();
}

class _NolState extends State<Nol> {
  bool showUzbek = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
        title: Text(
          "${widget.surah['englishName']} (${widget.surah['name']})",
          style: TextStyle(
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showUzbek = true;
                  });
                },
                child: Text('Uzbek'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showUzbek = false;
                  });
                },
                child: Text('Arabic'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.surah['ayahs'].length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    "Oyat ${index + 1}: ${showUzbek ? widget.surah['ayahs'][index]['text'] : widget.surah['ayahs'][index]['text_ar']}",
                    style: TextStyle(
                      fontSize: 20,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
