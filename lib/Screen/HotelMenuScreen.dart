import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
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

  Flushbar flushbar;


  showFlushbar(BuildContext context,String name, String price,user, String id){
    flushbar = Flushbar( 
      duration: Duration(seconds: 10),
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.GROUNDED,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticIn,
      isDismissible: true,
      userInputForm: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:  10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name,style: TextStyle(fontSize: 20,color: Colors.white),),
                      Text(price,style: TextStyle(fontSize: 20,color: Colors.white))
                    ],
                  ),
                ),
               AddingItems(name: name, price: price, user: user,id: id)
            ],
          ),
          ],
        )
      ),
    )..show(context) ;
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
                             
                             setState(() {
                               food = snapshot.data.documents[i].data['name'];
                               price = snapshot.data.documents[i].data['price'];
                             });
                             
                             showFlushbar(context,snapshot.data.documents[i].data['food'],snapshot.data.documents[i].data['price'],user,widget.id);
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

class AddingItems extends StatefulWidget {

  final name;
  final price;
  final user;
  final id;

  AddingItems({this.id,this.name,this.price,this.user});

  @override
   _AddingItemsState createState() => _AddingItemsState();
}
class _AddingItemsState extends State<AddingItems> {

  UserManagement _userManagement = new UserManagement();

  _HotelMenuScreenState toClose = _HotelMenuScreenState();

FirebaseUser user;
   FirebaseAuth firebaseAuth = FirebaseAuth.instance;


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

     @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getUser();
  }
  
    int noOfItems = 1;
    double _buttonwidth = 30;
   @override
   Widget build(BuildContext context) {
 
    return Column(
      children: <Widget>[
        Container(
          //margin: EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300],width: 2),
            borderRadius: BorderRadius.circular(15)
          ),
          padding: EdgeInsets.symmetric(vertical: 5),
          width: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: _buttonwidth,
                height: _buttonwidth,
                child: FlatButton(
                  child: Text("-",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                    ),
                  ),
                  onPressed: (){
                    setState(() {
                      if(noOfItems >1)
                      {
                        noOfItems--;
                      }
                    });
                  },
                ),
              ),
              Text(
                noOfItems.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white
                ),
              ),
              SizedBox(
                width: _buttonwidth,
                height: _buttonwidth,
                child: FlatButton(
                  child: Text("+",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                    ),
                  ),
                  onPressed: (){
                    setState(() {
                        noOfItems++;
                        print(noOfItems);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
         Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(top: 20.0,right: 8.0),
                child: FlatButton(
                  child: Text("Done"),
                  onPressed: (){
                    _userManagement.storeCurrentItemList(user,widget.name,widget.price, noOfItems, widget.id);
                  },
                  color: Colors.white,
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                ),
              ),
            )
      ],
    );
  }
} 

/*itemList.add( snapshot.data.documents[i].data['food']);
                      // int price = int.parse(snapshot.data.documents[i].data['price']) ;
                      // itemList.add(price);
                      print(itemList);*/