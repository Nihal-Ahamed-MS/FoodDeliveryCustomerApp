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
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: cartList(),
    );
  }

  
  Widget cartList(){
    if(_currentOrder != null){
      return Column(
        children: <Widget>[
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
                    title: Text(snapshot.data.documents[i].data['name']),
                    subtitle : Text(snapshot.data.documents[i].data['price']),
                    trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){
                      _userManagement.deletData(_uid, snapshot.data.documents[i].documentID);
                    }),
                  ),
                );
              },
            );
          },
        ),
      ),
      Container(
        padding: EdgeInsets.all(10.0),
        child: SizedBox(
          height: 50.0,
          width: double.infinity,
          child: RaisedButton(
            onPressed: (){
              _userManagement.placeOrder(_uid);
            },
            child: Text('Place Order',style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25
              ),
            ),
            color: Colors.blue,
          ),
        )
      )
        ],
      );
    }
    else{
      return Text('Loading. Please Wait for a second.....');
    }
  }
} 