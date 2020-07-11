import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class UserManagement{

  Firestore ref = Firestore.instance;

  getData()async{
    return await ref.collection('HotelManagement').snapshots();
  }

  getHotelMenu(String docID)async{
    return await ref.collection('HotelManagement')
            .document(docID)
            .collection('HotelMenu')
            .snapshots();
  }

  storeCurrentItemList(user,String foodName, String foodPrice,int quantity,String hotelID) async {

   ref.collection('UserRecentList').document(user.uid).setData({
        'name' : user.email
      });

    return await ref.collection('UserRecentList').document(user.uid).collection('CurrentList').add(
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
     return await ref.collection('UserRecentList')
            .document(uid)
            .collection('CurrentList')
            .snapshots();
  }

  updateData(user,selectedDoc,newValues){
      ref.collection('UserRecentList').document(user.uid).collection('CurrentList').document(selectedDoc).updateData(newValues).catchError((e){
         print(e);
       });
    }

    deletData(uid,docId){
      ref.collection('UserRecentList').document(uid).collection('CurrentList').document(docId).delete().catchError((e){
        print(e);
      });
    }

   placeOrder(String userID,int total){
     ref.collection('PlaceOrder').add(
       {
         'userId' : userID,
         'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
         'delivered' : false,
         'total' : total,
       }
     );
   }

}