import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'MyLocation.dart';


class Maps extends StatefulWidget {
  @override
   _MapsState createState() => _MapsState();
}
class _MapsState extends State<Maps> {
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
                  title: Text("Location", style: TextStyle(fontSize: 20.0, fontFamily: 'Montserrat')),
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
                height: 100.0,
              ),
 
         Container(
            height: 300.0,
            padding: EdgeInsets.all(10.0),
            child: Material(
              elevation: 7.0,
              borderRadius: BorderRadius.circular(10.0),                
               child: Container(
                      padding: EdgeInsets.only(top:15.0,bottom: 15.0),
                      child: FlutterMap(
                          options: MapOptions(
                            minZoom: 10.0,
                            center: LatLng(11.4070,79.6912)
                          ),    
                          layers: [
                            TileLayerOptions(
                              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a','b','c']
                            )
                          ],
                      ),
                    ),
            ),
          ),
           Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: EdgeInsets.only(right: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyLocation(),));
                              },
                              child: Text("View",style: TextStyle(fontSize: 20.0,color: Colors.blueAccent) 
                            )),
                            SizedBox(width: 5.0,),
                            IconButton(icon: Icon(Icons.keyboard_arrow_right),onPressed: (){},)
                          ],
                        ),
                      ),
                    )
      ],
    );
  }
} 


/*onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyLocation(),));
                },
                
                
                
                */