import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudMethod {

  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addOrder(orderData) async {
    //add login condition
    Firestore.instance.collection('orderList').add(orderData).catchError((e) {
      print(e);
    });
  }

  getData() async {
    return await Firestore.instance.collection('orderList').getDocuments();
  }
  
}