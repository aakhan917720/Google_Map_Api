import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class OsmScreen extends StatefulWidget {
  const OsmScreen({super.key});

  @override
  State<OsmScreen> createState() => _OsmScreenState();
}

class _OsmScreenState extends State<OsmScreen> {
  bool _isLocationServiceReady = false;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initLocationService();
    });
  }

  Future<void> _initLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    if (!mounted) return;

    setState(() {
      _isLocationServiceReady = true;
    });
  }

  // Helper function to show location details when marker is clicked
  void _showMarkerDetails(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Open Street Map",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: FlutterMap(
          mapController: _mapController,
          options:  MapOptions(
            initialCenter: LatLng(34.1983, 72.0304),
            initialZoom: 13,
            onTap: (tapPosition, point) {
              _mapController.move(point, _mapController.camera.zoom);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'A.Ahad.google_map_api',
            ),

            if (_isLocationServiceReady)
              const CurrentLocationLayer(),

            MarkerLayer(
              markers: [
                Marker(
                  point: const LatLng(34.1983, 72.0304),

                  width: 80,
                  height: 80,
                  child: GestureDetector(
                    onTap: () {
                      // Marker click par details show karne ke liye functions call kiya
                      _showMarkerDetails(
                          context,
                          "My Selected Location is",
                          "Mardan."
                      );
                    },
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 45,
                    ),
                  ),
                ),

                Marker(
                    point: LatLng( 34.149433, 71.742783),
                    width: 80,
                    height: 80,
                    child: GestureDetector(
                      onTap: (){
                        _showMarkerDetails(
                            context,
                            "My Selected Location",
                            "Charsadda"
                        );
                      },
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 45,
                      ),
                    ),
                ),


                Marker(
                  point:  LatLng( 34.21294, 71.94694),
                  width: 80,
                  height: 80,
                  child: GestureDetector(
                    onTap: (){
                      _showMarkerDetails(
                          context,
                          "My Selected Location",
                          "Sheikh Yousaf"
                      );
                    },
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 45,
                    ),
                  ),
                ),





                Marker(
                  point:  LatLng(37.0902, 95.7129),
                  width: 80,
                  height: 80,
                  child: GestureDetector(
                    onTap: (){
                      _showMarkerDetails(
                          context,
                          "My Selected Location",
                          "USA"
                      );
                    },
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 45,
                    ),
                  ),
                ),




              ],
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.my_location, color: Colors.white),
        onPressed: () {
          _mapController.move(
            const LatLng(34.1983, 72.0304),
            14.0,
          );
        },
      ),



    );
  }
}