import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String _uid;

  getUserId() async {
    final user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    _uid =uid ;
  }
  

  // Future fetchUser() async {
  //   // QuerySnapshot fetchOrder = await Firestore.instance.collection('users').where('uid',)
  //   return fetchOrder.documents;
  // }


  signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  _signOutDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('Sign Out from this account ?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              textColor: Colors.lime,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('OK'),
              textColor: Colors.lime,
              onPressed: signOut
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView(
        children: <Widget>[
          _showName(),
          _showEmail(),
          _showSignOut()
        ],
      ),
    );
  }

  Widget _showName() {
    return
    ListTile(
      title: Text('Name'),
      subtitle: Text('Name'),
    );
  }

  Widget _showEmail() {
    return
    ListTile(
      title: Text('Email'),
    );
  }

  Widget _showSignOut() {
    return
    ListTile(
      title: Text('SignOut'),
      onTap: _signOutDialog,
    );
  }

}