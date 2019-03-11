import 'package:flutter/material.dart';
import 'myHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formRegKey = GlobalKey<FormState>();
  final nameTxtCont = TextEditingController();
  final emailTxtCont = TextEditingController();
  final passTxtCont = TextEditingController();

  registerEmail(email, password) async {
    final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    if (user !=null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }

  // _registerAction(BuildContext context) {
    // if (_formRegKey.currentState.validate()) {
    //         Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
    //       } 
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _showRegForm(),
          _showButton(context)
        ],
      ),
    );
  }

  Widget _showRegForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Form(
        key: _formRegKey,
        child: Column(
          children: <Widget>[
            _showName(),
            _showEmail(),
            _showPassword()
          ],
        ),
      ),
    );
  }

  Widget _showName() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: TextFormField(
        controller: nameTxtCont,
          maxLines: 1,
          validator: (value) {
            if (value.isEmpty) {
              return 'Name can\'t be empty';
            }
          },
          decoration: InputDecoration(
              labelText: 'Name',
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder())),
    );
  }

  Widget _showEmail() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: TextFormField(
        controller: emailTxtCont,
        maxLines: 1,
        validator: (value) {
            if (value.isEmpty) {
              return 'Email can\'t be empty';
            }
          },
        decoration: InputDecoration(
            labelText: 'Email',
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border: OutlineInputBorder()),
      ),
    );
  }

  Widget _showPassword() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      child: TextFormField(
        controller: passTxtCont,
        maxLines: 1,
        obscureText: true,
        validator: (value) {
            if (value.isEmpty) {
              return 'Password can\'t be empty';
            }
          },
        decoration: InputDecoration(
            labelText: 'Password',
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border: OutlineInputBorder()),
      ),
    );
  }

  Widget _showButton(BuildContext context) {
    return
    Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: RaisedButton(
        onPressed:() {
          if (_formRegKey.currentState.validate()) {
            registerEmail(emailTxtCont.text, passTxtCont.text);
          } 
        },
        // _registerAction(context),
        color: Colors.lime,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Text('Register', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}