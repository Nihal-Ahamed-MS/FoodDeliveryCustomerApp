import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MyLocation extends StatefulWidget {
  @override
   _MyLocationState createState() => _MyLocationState();
}
class _MyLocationState extends State<MyLocation> {

  MapController controller = MapController();
  Position position;

  double lat;
  double lng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getCurrentPosition();
  }

   _getCurrentPosition() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
      });

    return position;
    
  }

    var points = <LatLng>[
    new LatLng(11.41,79.67203),
     new LatLng(11.398,79.673),
     new LatLng(11.387,79.677),
    new LatLng(11.3756,79.687),
     new LatLng(11.374,79.690),
     new LatLng(11.383,79.715),
     new LatLng(11.402,79.719),
     new LatLng(11.423,79.708),
     new LatLng(11.428,79.687),
     new LatLng(11.41,79.67203),
  ];


   @override
   Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.blueAccent,
       floatingActionButton: FloatingActionButton(
         onPressed: (){
           _getCurrentPosition();
         },
         backgroundColor: Colors.white,
         child: Icon(
           Icons.gps_fixed,
           color: Colors.blueAccent,
         ),
         ),
       body: Stack(
         children: <Widget>[
           Positioned(
                child: AppBar(
                  leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.of(context).pop();}),
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  title: Text("Address", style: TextStyle(fontSize: 20.0, fontFamily: 'Montserrat')),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.location_on),
                      onPressed: (){

                      },   
                    )
                  ],
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
              _flutterMap(),
              
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
 
         Flexible(
           child: Container(
              height: 700.0,
              padding: EdgeInsets.all(10.0),
              child: FlutterMap(
                mapController: controller,
                            options: MapOptions(
                              minZoom: 6.0,
                              center: LatLng(lat,lng)
                            ),    
                            layers: [
                              TileLayerOptions(
                                urlTemplate: "https://api.mapbox.com/styles/v1/lucifer-king/ckcgiqpa4145z1jo5dfp7pd0q/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibHVjaWZlci1raW5nIiwiYSI6ImNrY2dpajN5YzAzNHkyeHM1bXpmcDR5YWsifQ.EltsmZxxPg8Y6P70qdBrmA",
                                additionalOptions: {
                                  'accessToken' : 'pk.eyJ1IjoibHVjaWZlci1raW5nIiwiYSI6ImNrY2dpbDk3bjBmeWwyeHFxM2tlbmN3cGYifQ.TpPHLmlFiMUZjqFj2tAgEg',
                                  'id' : 'mapbox.mapbox-streets-v8'
                                }
                              ),
                              PolylineLayerOptions(
                              polylines : [
                                Polyline(
                                  points: points,
                                  strokeWidth: 5.0,
                                  color: Colors.blue
                                )
                              ]
                            )
                            ],
                        ),
            ),
         ),
          
      ],
    );
  }

//<--------------------   This is the Geolocation Package Coding for getting user location   ----------------------------->

  // getPermission() async {
  //   final GeolocationResult result = await Geolocation.requestLocationPermission(
  //     permission: LocationPermission(
  //       android: LocationPermissionAndroid.fine,
  //       ios: LocationPermissionIOS.always
  //     ),
  //     openSettingsIfDenied: true
  //   );
  //   return result;
  // }

  // getLocation(){
  //   return getPermission().then((result) async {
  //     if(result.isSuccessful){
  //       print("j");
  //       final _coOrdinates = await Geolocation.currentLocation(accuracy: LocationAccuracy.best);
  //       //return _coOrdinates;
  //     }
  //   });
  // }

  // buildMap(){
  //   _getCurrentPosition().then((response){
  //     if(response.isSuccessful){
  //       response.listen((value){
  //         controller.move(LatLng(value.location.latitude,value.location.longitude),15.0);
          
  //       });
  //     }
  //   });
  // }
} 
