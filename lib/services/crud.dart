import 'package:cloud_firestore/cloud_firestore.dart';
class Crud{

 getData() async{
     return await Firestore.instance.collection('HotelManagement').getDocuments();
    //  String id;
    //  return await Firestore.instance.collection('HotelManagement').snapshots().listen((event) {
    //    event.documents.forEach((doc) {
    //      id = doc.documentID;
    //      return Firestore.instance.collection('HotelManagement').document(id).collection('HotelBasicInfo').getDocuments();
    //    });
    //  });


  }

}


