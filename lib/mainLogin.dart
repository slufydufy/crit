import 'package:flutter/material.dart';
import 'myHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'crud.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'emailLogin.dart';

class MainLogin extends StatefulWidget {

  @override
  _MainLoginState createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
  BuildContext scafoldContext;

  CrudMethod crudObj = CrudMethod();
  GoogleSignInAccount _currentUser;

  GoogleSignIn _gSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly'
    ]
  );

  googleSignIn() async {
    _loadingDialog(context);
    try {
      GoogleSignInAccount googleSignInAccount = await _gSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      AuthCredential authCredential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
      );
      FirebaseUser user = await FirebaseAuth.instance.signInWithCredential(authCredential);
      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

      QuerySnapshot fetchUser = await Firestore.instance.collection('users').where('uid', isEqualTo: currentUser.uid).getDocuments();
      if (fetchUser != null) {
        Navigator.popUntil(context, ModalRoute.withName('/'));
      } else {
        crudObj.addUser({
        'uid' : currentUser.uid,
        'name' : user.displayName,
        'email' : user.email,
      }).then((result) {
        Navigator.popUntil(context, ModalRoute.withName('/'));
        currentUser.sendEmailVerification();
      });
      }
    } 
    catch (e) {
      print(e);
    }
  }

  _loadingDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Sign In ')),
          content: Container(
            width: 84,
            height: 84,
            child: Center(
              child: CircularProgressIndicator()
              )),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _gSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _gSignIn.signInSilently();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: ListView(
        children: <Widget>[
          Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
              _showLogo(context),
              _showEmailLogin(),
              _showGoogleLogin(),
              _showSkipText(context),
          ],
        ),
        ],
      )
    );
  }

  Widget _showLogo(BuildContext context) {
    return 
    Container(
      height: MediaQuery.of(context).size.width,
      child: Center(
        child: Image.asset('assets/images/bw.png',
        height: MediaQuery.of(context).size.width / 1.5,
        width: MediaQuery.of(context).size.width / 1.5,
        ),
      ),
    )
    ;
  }

  Widget _showEmailLogin() {
    return
    Container(
      color: Colors.grey[600],
      padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 0.0),
      child: 
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EmailLogin()));
          },
          child: Container(
            width: MediaQuery.of(context).size.width /2,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.white, width: 0.5)
            ),
            child: Row(
              children: <Widget>[
                Text('Email Sign In', style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white
                    ),),
                    Spacer(),
                    Icon(Icons.email, color: Colors.white,)
              ],
            ),
          ),
        ),
    );
  }

  Widget _showGoogleLogin() {
    return
    Container(
      color: Colors.grey[600],
      padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 0.0),
      child: 
        GestureDetector(
          onTap: googleSignIn,
          child: Container(
            width: MediaQuery.of(context).size.width /2,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.white, width: 0.5)
            ),
            child: Row(
              children: <Widget>[
                Text('Google Sign In', style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white
                    ),),
                    Spacer(),
                    Image.asset('assets/images/g.png', width: 24, height: 24)
              ],
            ),
          ),
        ),
    );
  }

  Widget _showSkipText(BuildContext context) {
    return 
    Row(
      children: <Widget>[
        Spacer(),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 32.0,0.0, 0.0),
          child: GestureDetector(
              onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
            },
            child: Text('Skip', style: TextStyle(
              color: Colors.white,
              fontSize: 12
            ))),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 32.0, 32.0, 0.0),
          child: IconButton(
            padding: EdgeInsets.all(0.0),
          icon: Icon(Icons.keyboard_arrow_right, 
            color: Colors.white,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
            },
        ))
      ],
    );
  }
}