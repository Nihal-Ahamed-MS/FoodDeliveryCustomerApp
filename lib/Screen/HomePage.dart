import '../Maps/Map.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerapp/services/UserManagement.dart';
import 'package:customerapp/services/crud.dart';
import 'HotelMenuScreen.dart';
import 'package:customerapp/Authorization/SignIn.dart';
import 'package:customerapp/Authorization/SignUp.dart';
class HomePage extends StatefulWidget {
  @override
   _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;

  Crud curd = new Crud();
  Stream hotelinfo;

  UserManagement _userManagement = UserManagement();

    checkAuthState(){
    firebaseAuth.onAuthStateChanged.listen((user) async {
      if(user == null){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignUp()));
      }
    });
  }

    getUser() async {
      FirebaseUser firebaseUser = await firebaseAuth.currentUser();
      await firebaseUser?.reload();
      firebaseUser = await firebaseAuth.currentUser();

      if(firebaseUser!=null){
        setState(() {
          this.user = firebaseUser;
        });
      }
    }

    signOut() async {
    firebaseAuth.signOut();
  }
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.checkAuthState();
    this.getUser();
    this.getData();
  }

  void getData(){
    _userManagement.getData().then((result){
      setState(() {
        hotelinfo = result;
      });
    });
  }



 Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.blueAccent,
       body: Stack(
         children: <Widget>[
           Positioned(
                child: AppBar(
                  leading: IconButton(icon: Icon(Icons.location_on), onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Maps()));
                  }),
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  title: Text("UI MART", style: TextStyle(fontSize: 20.0, fontFamily: 'Montserrat')),
                  
                 ),
              ),
              Positioned(
                top: 100,
                left: (MediaQuery.of(context).size.width /2) - 180.0,
                child: Column(
                  children: <Widget>[
                    Container(
                       child: Text('21, West Car Street,',style: TextStyle(color: Colors.white,fontSize: 20),),
                    ),
                   
                  ],
                ),
              ),
              Positioned(
                top: 130,
                left: (MediaQuery.of(context).size.width /2) - 180.0,
                child:  Container(
                       child: Text('Chidabaram.',style: TextStyle(color: Colors.white,fontSize: 20),),
                    ),
              ),
              SizedBox(height: 50),
              Positioned(
                top: 200.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45.0),
                      topRight: Radius.circular(45.0),
                    ),
                    color: Colors.white
                  ),
                  height: MediaQuery.of(context).size.height - 100.0,
                  width: MediaQuery.of(context).size.width,
                )
              ),
               menuList()
         ],
       )
     );
  }

   Widget menuList(){
    if(hotelinfo != null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
                height: 200.0,
              ),
          Container(
            padding: EdgeInsets.all(15.0),
            child: Text("Restaurents you may look for...",
                    style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
            ),
            ),
          ), 
          Expanded(
            child: SingleChildScrollView(
             child: SizedBox(
                height: 400.0,
                child : StreamBuilder(
                  stream: hotelinfo,
                  builder: (context,snapshot){
                    return ListView.builder(
                        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context,i){
                          return Card(
                            shadowColor: Colors.blue,
                            elevation: 7.0,
                            
                            child: ListTile(
                                title: Text(snapshot.data.documents[i].data['name']),
                                subtitle : Text(snapshot.data.documents[i].data['type']),
                                leading: Image(
                                  image: NetworkImage(snapshot.data.documents[i].data['photoUrl']),
                                ),
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HotelMenuScreen(id: snapshot.data.documents[i].documentID,name:snapshot.data.documents[i].data['name']),));
                              },
                              ),
                            );
                        },
                      );
                  },
                ),
              ),
            ),
          )
        ],
      );
    }
    else{
      return Text('Loading. Please Wait for a second.....');
    }
  }


   Widget buildFittedBox(String url, String title, String subtitle,String docID) {

       if(hotelinfo!=null){
         return GestureDetector(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0,),
                    FittedBox(
                          child: Container(
                            height: 100.0,
                            width: 350.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Colors.white,
                              boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                            ),
                            child: Row(  
                              
                              children: <Widget>[
                                Image(
                                  image: NetworkImage(url),
                                  height: 100.0,
                                  width: 100.0,
                                  
                                ),
                                Column(
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.only(top: 5.0,right:5.0)),
                                    Text(title,style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold
                                      
                                    ),
                                    textAlign: TextAlign.right,
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 10.0)),
                                    Text(subtitle,style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.grey
                                    ),
                                    textAlign: TextAlign.right
                                    ),
                                  ],
                                ),
                                //availabilityOpenClosed(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: (){
                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => HotelMenuScreen(id: docID),));
                  
                },
       );
       }
       else{
         return Center(
           child: Text("Loading Please Wait...")
         );
       }
       
     }
}

class HoteMenuScreen {
} 



