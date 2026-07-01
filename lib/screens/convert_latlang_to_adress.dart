import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';


class ConvertLatlangToAdress extends StatefulWidget {
  const ConvertLatlangToAdress({super.key});

  @override
  State<ConvertLatlangToAdress> createState() => _ConvertLatlangToAdressState();
}

class _ConvertLatlangToAdressState extends State<ConvertLatlangToAdress> {

  late var stAdress = '';

  String  stAdd = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ConvertLatlangToAddress", style: TextStyle(color: Colors.white, fontSize: 25),), centerTitle: true, backgroundColor: Colors.blue,),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text(stAdress),
            Text(stAdd),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                color: Colors.blue,
                child: GestureDetector(
                  onTap: ()async{

                    List<Placemark> placemarks = await placemarkFromCoordinates(34.1983, 72.0304);
                    List<Location> locations = await locationFromAddress("Gronausestraat 710, Enschede");


                    print(locations.first.latitude);
                    print(locations.first.longitude);

                    Placemark place = placemarks.first;
                    print(place.street);
                    print(place.locality);
                    print(place.country);

                    setState(() {

                      stAdress = locations.last.longitude.toString()+ " " +locations.last.longitude.toString();
                      stAdd = placemarks.reversed.last.country.toString()+ " "+ placemarks.reversed.last.country.toString();


                    });

                  },
                  child: Center(child: Text("Convert", style: TextStyle(color: Colors.white, fontSize: 15),)),

                ),
              ),
            )


          ],


        ),
      ),
    );
  }
}








