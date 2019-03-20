import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adminPage.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  Future _userData;
  Future _adminData;
  String crntUid;

  Future fetchAdmin() async {
    QuerySnapshot admQuery = await Firestore.instance.collection('adminUid').getDocuments();
    return admQuery.documents;
  }

  Future fetchUser() async {
    final curentUser = await FirebaseAuth.instance.currentUser();
    final _uid = curentUser.uid;
    crntUid = _uid.toString();
    QuerySnapshot userQuery = await Firestore.instance.collection('users').where('uid', isEqualTo: '$_uid').getDocuments();
    return userQuery.documents;
  }


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
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: signOut
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _userData = fetchUser();
    _adminData = fetchAdmin();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: 
      FutureBuilder(
        future: _userData,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.length > 0) {
            return
            ListView(
            children: <Widget>[
              _showName(snapshot.data[0]),
              _showEmail(snapshot.data[0]),
              Divider(),
              _showSignOut(),
              _showadmin()
        ],
      );
          }
        },
      )
    );
  }

  Widget _showName(item) {
    return
    ListTile(
      title: Text('Name'),
      subtitle: Text(item['name']),
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }

  Widget _showEmail(data) {
    return
    ListTile(
      title: Text('Email'),
      subtitle: Text(data['email']),
    );
  }

  Widget _showSignOut() {
    return
    ListTile(
      title: Text('SignOut'),
      onTap: _signOutDialog,
    );
  }

  Widget _showadmin() {
    return
    FutureBuilder(
      future: _adminData,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return
          Center(child: Text('Loading'),);
        } else {
          if (crntUid == snapshot.data[0].data['admUid'] || crntUid == snapshot.data[1].data['admUid'] || crntUid == snapshot.data[2].data['admUid']) {
            return
            ListTile(
              title: Text('Admin Page'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage()));
              },
            );
          } else {
            return Container();
          }
        }
      },
    );
  }

}