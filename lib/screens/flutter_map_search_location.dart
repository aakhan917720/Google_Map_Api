import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FlutterMapSearchLocation extends StatefulWidget {
  const FlutterMapSearchLocation({super.key});

  @override
  State<FlutterMapSearchLocation> createState() => _FlutterMapSearchLocationState();
}

class _FlutterMapSearchLocationState extends State<FlutterMapSearchLocation> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _placeList = [];
  bool _isLoading = false;

  // 1. OpenStreetMap (Nominatim) search function
  void getSuggestion(String input) async {
    // Agar input khali ho ya sirf spaces hon to API hit na karein
    if (input.trim().isEmpty) {
      setState(() {
        _placeList = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Spaces aur special characters ko URL ke mutabiq convert karne ke liye encode kiya
    String encodedInput = Uri.encodeComponent(input.trim());

    // OpenStreetMap ki sahi Request URL format
    String baseUrl = "https://nominatim.openstreetmap.org/search";
    String request = "$baseUrl?q=$encodedInput&format=json&limit=5";

    try {
      var response = await http.get(
        Uri.parse(request),
        // User-Agent header dena LAZMI hai warna data nahi aayega
        headers: {
          'User-Agent': 'Ahad_Map_App_Search_Service',
          'Accept-Language': 'en',
        },
      );

      if (response.statusCode == 200) {
        // OSM seedha ek List wapis karta hai, isme ["Predictions"] nahi hota
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          _placeList = data;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        debugPrint("OSM Status Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Exception Catch: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      onChange();
    });
  }

  void onChange() {
    // Phir se search query trigger karein jab user type kare
    getSuggestion(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flutter Map Search Location",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search Input Field
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Search any place name...",
                suffixIcon: _isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
                  ),
                )
                    : null,
              ),
            ),
            const SizedBox(height: 10),

            // 2. Suggestions List Box UI
            Expanded(
              child: _placeList.isEmpty
                  ? const Center(child: Text("No suggestions yet"))
                  : ListView.builder(
                itemCount: _placeList.length,
                itemBuilder: (context, index) {
                  final place = _placeList[index];
                  // OSM Response mein jagah ka naam 'display_name' ke andar hota hai
                  return ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.blue),
                    title: Text(
                      place['display_name'] ?? "Unknown Place",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      // Jab user suggestion par click karega:
                      double lat = double.parse(place['lat'].toString());
                      double lon = double.parse(place['lon'].toString());

                      // Aap is lat/lon ko wapis map screen par bhej sakte hain
                      debugPrint("Selected: $lat, $lon");
                    },
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