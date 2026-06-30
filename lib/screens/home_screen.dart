
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Google Map", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
      //   backgroundColor: Colors.blue,
      //   centerTitle: true,
      // ),
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
      ),
    );
  }
}
