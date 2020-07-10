import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocation/geolocation.dart';
class MyLocation extends StatefulWidget {
  @override
   _MyLocationState createState() => _MyLocationState();
}
class _MyLocationState extends State<MyLocation> {

  MapController controller = MapController();

   @override
   Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.blueAccent,
       body: Stack(
         children: <Widget>[
           Positioned(
                child: AppBar(
                  leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.of(context).pop();}),
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  title: Text("Address", style: TextStyle(fontSize: 20.0, fontFamily: 'Montserrat')),
                 ),
              ),
               SizedBox(height: 50),
              Positioned(
                top: 80.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  height: MediaQuery.of(context).size.height - 50.0,
                  width: MediaQuery.of(context).size.width,
                )
              ),
              _flutterMap()
         ],
       )
     );
  }

    _flutterMap(){
    return Column(
      children: <Widget>[
        Container(
                height:90.0,
              ),
 
         Container(
            height: 600.0,
            padding: EdgeInsets.all(10.0),
            child: FlutterMap(
              mapController: controller,
                          options: MapOptions(
                            minZoom: 6.0,
                            center: buildMap()
                          ),    
                          layers: [
                            TileLayerOptions(
                              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a','b','c']
                            )
                          ],
                      ),
          ),
      ],
    );
  }

  getPermission() async {
    final GeolocationResult result = await Geolocation.requestLocationPermission(
      permission: LocationPermission(
        android: LocationPermissionAndroid.fine,
        ios: LocationPermissionIOS.always
      ),
      openSettingsIfDenied: true
    );
    return result;
  }

  getLocation(){
    return getPermission().then((result) async {
      if(result.isSuccessful && result != null){
        print("j");
        final _coOrdinates = await Geolocation.currentLocation(accuracy: LocationAccuracy.best);
        //return _coOrdinates;
      }
    });
  }

  buildMap(){
    getLocation().then((response){
      if(response.isSuccessful){
        response.listen((value){
          controller.move(LatLng(value.location.latitude,value.location.longitude),15.0);
        });
      }
    });
  }
} 
