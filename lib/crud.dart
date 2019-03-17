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
    Firestore.instance.collection('orderList').add(orderData).catchError((e) {
      print(e);
    });
  }

  Future<void> addUser(userData) async {
    Firestore.instance.collection('users').add(userData).catchError((e) {
      print(e);
    });
  }

  Future<void> confirmPayment(orderUid, confirmData) async {
    Firestore.instance.collection('orderList').document('$orderUid').setData(confirmData, merge: true).catchError((e) {
      print(e);
    });
  }

  Future<void> loginUser(email, password) async {
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).catchError((e) {
      print(e);
    });
  }

  getData() async {
    return await Firestore.instance.collection('orderList').getDocuments();
  }

}