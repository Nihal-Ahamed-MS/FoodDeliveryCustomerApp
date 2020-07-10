import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:customerapp/services/UserManagement.dart';

class CartPage extends StatefulWidget {
  @override
   _CartPageState createState() => _CartPageState();
}
class _CartPageState extends State<CartPage> {

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserManagement _userManagement = new UserManagement();
  FirebaseUser user;
  Stream _currentOrder;
  String _uid;

  _CalculateState _calculateState = _CalculateState();

 getUser() async {
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await firebaseAuth.currentUser();

    if(firebaseUser!=null){
      setState(() {
        this.user = firebaseUser;
        this._uid = firebaseUser.uid;
      });
      getData();
    }
  }

    getData(){

     _userManagement.getStoreCurrentItemList(_uid).then((result){
       setState(() {
         _currentOrder = result;
       });
     });

   }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getUser();
  }
   

   @override
   Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
       body: Stack(
         children: <Widget>[
           Positioned(
              child: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text("Cart", style: TextStyle(fontSize: 20.0, fontFamily: 'Montserrat')),
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
           cartList()
         ],
       )
    );
  }

  
  Widget cartList(){
    if(_currentOrder != null){
      return Column(
        children: <Widget>[
           Container(
                height: 100.0,
              ),
          Expanded(
            child :  StreamBuilder(
          stream: _currentOrder,
          builder: (context,snapshot){
            return ListView.builder(
                padding: EdgeInsets.all(5.0),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context,i){
                  return Card(
                 child: ListTile(
                   leading: Text(snapshot.data.documents[i].data['quantity'].toString() + " " + " x "),
                    title: Text(snapshot.data.documents[i].data['name']),
                    subtitle : Text(snapshot.data.documents[i].data['price']),
                    trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){
                      _userManagement.deletData(_uid, snapshot.data.documents[i].documentID);
                      
                      _calculateState._getAmount();
                      
                    }),
                  ),
                );
              },
            );
          },
        ),
      ),
      Calculate(id : _uid),
      
      
        ],
      );
    }
    else{
      return Text('Loading. Please Wait for a second.....');
    }
  }

} 

class Calculate extends StatefulWidget {
  final id;
  Calculate({this.id});
  @override
  _CalculateState createState() => _CalculateState();
}

class _CalculateState extends State<Calculate> {

  UserManagement _userManagement = UserManagement();

  List<int> sum = [];

  int _total = 0;

  int _grandTotal = 0;

  int incre=0;

  _getAmount() async{
     return await Firestore.instance.collection('UserRecentList')
            .document(widget.id)
            .collection('CurrentList')
            .snapshots()
            .listen((value) => value.documents.forEach((element) {
              int tempPrice=0;
              int tempQuantity=0;
              int tempTotal = 0;  
            setState(() {
              tempPrice = int.parse(element['price']); 
              tempQuantity = element['quantity'];
              tempTotal = tempPrice * tempQuantity;
              });
              
              if(tempTotal!=null){
                sum.add(tempTotal);
                setState(() {
                  tempTotal = null;
                });
              }
              incre++;
              if(value.documents.length == incre){
                _calculate();
                setState(() {
                  incre = 0;
                });
              }
          }));
  }

    _calculate(){
          if (sum.isNotEmpty) {
                setState(() {
                  _total =0;
                  _grandTotal = 0;
                });
                for (var i = 0; i < sum.length; i++) {
                     print(_total);
                    _total+=sum[i];
                   
                  
              }
              setState(() {
                _grandTotal = _total +40;
              });
              sum.clear();
              }
     }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAmount();
    _total=0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20.0),
           child: Material(
              elevation: 7.0,
              borderRadius: BorderRadius.circular(5.0),
               child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Sub-Total :", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.black)),
                        
                        Text("₹ " + _total.toString(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.grey[500]))
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Delivery Charges :", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.black)),
                        
                        Text("₹ 30", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.grey[500]))
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Parcel Charges :", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.black)),
                        
                        Text("₹ 10", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.grey[500]))
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Total :", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.black)),
                        
                        Text("₹ " + _grandTotal.toString(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.grey[500]))
                      ],
                    ),
                  ],
                ),
              ),
            )
          ),
          Container(
        padding: EdgeInsets.all(10.0),
        child: SizedBox(
          height: 50.0,
          width: double.infinity,
          child: RaisedButton(
            onPressed: (){
              _userManagement.placeOrder(widget.id,_grandTotal);
            },
            child: Text('Place Order',style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25
              ),
            ),
            color: Colors.blueAccent,
          ),
        )
      ),
      ],
    );
  }
}