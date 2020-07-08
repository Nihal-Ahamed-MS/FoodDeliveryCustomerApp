import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:customerapp/services/UserManagement.dart';

class HotelMenuScreen extends StatefulWidget {
  
  final id;
  final name;

  HotelMenuScreen({this.id,this.name});
  
  @override
   _HotelMenuScreenState createState() => _HotelMenuScreenState();
}
class _HotelMenuScreenState extends State<HotelMenuScreen> {

   FirebaseAuth firebaseAuth = FirebaseAuth.instance;
   UserManagement _userManagement = new UserManagement();
   FirebaseUser user;

   GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

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

  _showSnackBar(){
    final snackbar = new SnackBar(
      content: Text('View your cart for checkout'),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.blueAccent,
      action: new SnackBarAction(
        label: 'OK',
        onPressed: (){
          print('hi');
        },
        textColor: Colors.white,
      ),
    );
    _globalKey.currentState.showSnackBar(snackbar);
  }

   Stream hotelMenu;
   String food='',price='';

  //Map items={};

  List <Map<String,dynamic>> itemList;

   getData(){

     _userManagement.getHotelMenu(widget.id).then((result){
       setState(() {
         hotelMenu = result;
       });
     });

   }
   
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
    this.getUser();
  }

   @override
   Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.blueAccent,
       body: Stack(
         children: <Widget>[
           Positioned(
              child: AppBar(
              leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.of(context).pop();}),
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(widget.name, style: TextStyle(fontSize: 20.0, fontFamily: 'Montserrat')),
            ),
           ),
            SizedBox(height: 50),
              Positioned(
                top: 80.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      // topLeft: Radius.circular(45.0),
                      // topRight: Radius.circular(45.0),
                    ),
                    color: Colors.white
                  ),
                  height: MediaQuery.of(context).size.height - 50.0,
                  width: MediaQuery.of(context).size.width,
                )
              ),
           menuList()
         ],
       )
    );
  }

  Widget menuList(){
    if(hotelMenu != null){
      return Column(
        children: <Widget>[
          Container(
                height: 100.0,
              ),
          Expanded(
            child: StreamBuilder(
              stream: hotelMenu,
              builder: (context,snapshot){
                return ListView.builder(
                    padding: EdgeInsets.all(5.0),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context,i){
                      return (snapshot.data.documents[i].data['availability']) ? Card(
                        elevation: 7.0,
                     child: ListTile(
                        title: Text(snapshot.data.documents[i].data['food']),
                        subtitle : Text(snapshot.data.documents[i].data['price']),

                        trailing: IconButton(icon: Icon(Icons.add), onPressed: (){
                          if (snapshot.data.documents[i].data['food'] == food && snapshot.data.documents[i].data['price'] == price) {
                            print('same food');
                            print(snapshot.data.document[i].documentID);
                          } else {
                             _userManagement.storeCurrentItemList(user, snapshot.data.documents[i].data['food'], snapshot.data.documents[i].data['price'],widget.id);
                             setState(() {
                               food = snapshot.data.documents[i].data['name'];
                               price = snapshot.data.documents[i].data['price'];
                             });
                             _showSnackBar();
                          }
                         
                        }),       
                      ),
                    ) : SizedBox(height: 2.0,);
                  },
                );
              },
            ),
          ),
        ],
      );
    }
    else{
      return Text('Loading. Please Wait for a second.....');
    }
  }
} 

/*itemList.add( snapshot.data.documents[i].data['food']);
                      // int price = int.parse(snapshot.data.documents[i].data['price']) ;
                      // itemList.add(price);
                      print(itemList);*/