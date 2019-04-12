import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adminPage.dart';
import 'brandPage.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  Future _userData;
  Future _adminData;
  String crntUid;
  String _email;
  // GoogleSignIn _gSignIn = GoogleSignIn();


  Future fetchAdmin() async {
    QuerySnapshot admQuery = await Firestore.instance.collection('adminUid').getDocuments();
    return admQuery.documents;
  }

  Future fetchUser() async {
    final curentUser = await FirebaseAuth.instance.currentUser();
    final _uid = curentUser.uid;
    _email = curentUser.email;
    crntUid = _uid.toString();
    QuerySnapshot userQuery = await Firestore.instance.collection('users').where('uid', isEqualTo: '$_uid').getDocuments();
    return userQuery.documents;
  }

  _resetDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Password'),
          content: Text('Reset your account password ?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: resetPassword
            ),
          ],
        );
      },
    );
  }

  resetPassword() async{
    Navigator.pop(context);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
    } catch (e) {
      } finally {
        _confirmResetDialog();
      }
  }

  _confirmResetDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Password'),
          content: Text('Password reset link has been sent to your email, please check your email'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                signOut();
              }
            ),
          ],
        );
      },
    );
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    // await _gSignIn.signOut();
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
              _showReset(),
              _showBrandPage(),
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

  Widget _showName(data) {
    return
    ListTile(
      title: Text(data['name']),
      subtitle: Text('Name')
    );
  }

  Widget _showEmail(data) {
    return
    ListTile(
      title: Text(data['email']),
      subtitle: Text('Email'),
    );
  }

  Widget _showReset() {
    return
    ListTile(
      title: Text('Reset Password'),
      subtitle: Text('Reset your account password'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: _resetDialog
    );
  }

  Widget _showBrandPage() {
    return
    ListTile(
      title: Text('Brand Page'),
      subtitle: Text('Create / Manage your Brand'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => BrandPage()));
      }
    );
  }

  Widget _showSignOut() {
    return
    ListTile(
      title: Text('Sign Out'),
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
              trailing: Icon(Icons.arrow_forward_ios),
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