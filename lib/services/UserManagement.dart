import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class UserManagement{
  getData()async{
    return await Firestore.instance.collection('HotelManagement').snapshots();
  }

  getHotelMenu(String docID)async{
    return await Firestore.instance.collection('HotelManagement')
            .document(docID)
            .collection('HotelMenu')
            .snapshots();
  }

  storeCurrentItemList(user,String foodName, String foodPrice,int quantity,String hotelID) async {

    Firestore.instance.collection('UserRecentList').document(user.uid).setData({
        'name' : user.email
      });

    return await Firestore.instance.collection('UserRecentList').document(user.uid).collection('CurrentList').add(
      {
        'name' : foodName,
        'price' : foodPrice,
        'hotelId' : hotelID,
        'quantity' : quantity
      }
    ).then((value) => print('succesffully for saved'))
      .catchError((e){
        print(e);
      });
  }

  getStoreCurrentItemList(uid) async{
     return await Firestore.instance.collection('UserRecentList')
            .document(uid)
            .collection('CurrentList')
            .snapshots();
  }

  updateData(user,selectedDoc,newValues){
       Firestore.instance.collection('UserRecentList').document(user.uid).collection('CurrentList').document(selectedDoc).updateData(newValues).catchError((e){
         print(e);
       });
    }

    deletData(uid,docId){
      Firestore.instance.collection('UserRecentList').document(uid).collection('CurrentList').document(docId).delete().catchError((e){
        print(e);
      });
    }

   placeOrder(String userID,int total){
     Firestore.instance.collection('PlaceOrder').add(
       {
         'userId' : userID,
         'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
         'delivered' : false,
         'total' : total,
       }
     );
   }

}