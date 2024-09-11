import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_mask/widget_mask.dart';

class besh extends StatefulWidget {
  @override
  _beshState createState() => _beshState();
}

class _beshState extends State<besh> {
  // Rasmlar listi
  List<String> imageUrls = List.generate(
      30, (index) => 'https://picsum.photos/200/300?random=$index');

  // Har bir rasmning bosilgani yoki bosilmagani (ko'rinishi yoki ko'rinmasligi)
  List<bool> isImageTapped = List.generate(30, (index) => false);

  @override
  void initState() {
    super.initState();
    _loadImageStates(); // Load saved states when initializing
  }

  // Load the image states from SharedPreferences
  Future<void> _loadImageStates() async {
    final prefs = await SharedPreferences.getInstance();
    final tappedStates = prefs.getStringList('isImageTapped') ??
        List.generate(30, (index) => 'false');
    setState(() {
      isImageTapped = tappedStates.map((state) => state == 'true').toList();
    });
  }

  // Save the image states to SharedPreferences
  Future<void> _saveImageStates() async {
    final prefs = await SharedPreferences.getInstance();
    final tappedStates =
        isImageTapped.map((tapped) => tapped ? 'true' : 'false').toList();
    await prefs.setStringList('isImageTapped', tappedStates);
  }

  // Rasmlarni yangilash funksiyasi
  void _refreshImages() {
    setState(() {
      // Yangi rasmlar ro'yxati generatsiya qilinadi
      imageUrls = List.generate(
          30,
          (index) =>
              'https://picsum.photos/200/300?random=${index + DateTime.now().millisecondsSinceEpoch}');
      // Barcha rasmlar qayta ko'rinmas bo'ladi
      isImageTapped = List.generate(30, (index) => false);
      _saveImageStates(); // Save the updated state
    });
  }

  @override
  void dispose() {
    _saveImageStates(); // Save states when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('1989',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
        backgroundColor: Color.fromARGB(255, 19, 0, 104),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: _refreshImages,
              child: Container(child: Image.asset("assets/refresh.png")),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            height: 550,
            width: 500,
            child: GridView.builder(
              padding: EdgeInsets.all(8.0), // Gridga tashqi bo'sh joy
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisExtent: 100, // 3 ustunli grid
                crossAxisSpacing: 8.0, // Ustunlar orasidagi bo'sh joy
                mainAxisSpacing: 8.0, // Qatorlar orasidagi bo'sh joy
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isImageTapped[index] =
                          !isImageTapped[index]; // Toggle image visibility
                      _saveImageStates(); // Save state after change
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors
                          .grey, // Rasm ko'rinmaganda bo'sh joy kul rangda bo'ladi
                      borderRadius: BorderRadius.circular(
                          12), // Burchaklarni yumaloq qilish
                      image:
                          isImageTapped[index] // Rasm bosilganda rasm ko'rinadi
                              ? DecorationImage(
                                  image: NetworkImage(imageUrls[index]),
                                  fit: BoxFit
                                      .cover, // Rasm yonlari kesilib to'liq sig'diriladi
                                )
                              : null,
                    ),
                    child: isImageTapped[index]
                        ? null // Agar rasm ko'rinayotgan bo'lsa, child kerak emas
                        : Center(
                            child: Text(
                                "")), // Bosilmagan rasm o'rniga indikator ko'rinadi
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: besh(),
  ));
}
