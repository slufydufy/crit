import 'package:flutter/material.dart';
import 'register.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailLogin extends StatefulWidget {

  @override
  EmailLoginState createState() => EmailLoginState();
}

class EmailLoginState extends State<EmailLogin> {
  final _formLoginkey = GlobalKey<FormState>();
  final passwordTxtCont = TextEditingController();
  final emailTxtCont = TextEditingController();

  BuildContext scafoldContext;

  void createSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.black,
    );
    Scaffold.of(scafoldContext).showSnackBar(snackBar);
  }

  signInEmail() async {
    FirebaseUser user;
    try {
      user = await FirebaseAuth.instance.
        signInWithEmailAndPassword(email: emailTxtCont.text, password: passwordTxtCont.text);
    } catch (e) {
      print(e);
      if (e.toString() == 'PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)') {
        createSnackBar('The password is invalid or the user does not have a password');
      } else if (e.toString() == 'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)') {
        createSnackBar('The email address is badly formatted');
      } else if (e.toString() == 'PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)') {
        createSnackBar('There is no user record found');
      } else {
        createSnackBar('Login Error');
      }
      
    } finally {
      if (user != null ) {
        print(user);
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }
    }
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (BuildContext context) {
          scafoldContext = context;
          return ListView(
              children: <Widget>[
                _showText(),
                _loginForm()
              ],
          );
        },
      )
    );
  }

  Widget _showText() {
    return
    Padding(
      padding: EdgeInsets.only(top: 32.0, left: 32.0),
      child: Text('Email Sign In', style: TextStyle(
        fontSize: 28,
        color: Colors.grey[800]
      ),),
    );
  }

  Widget _loginForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Form(
        key: _formLoginkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _showEmail(),
            _showPassword(),
            _showButton(),
            _showRegister(context)
          ],
        ),
      ),
    );
  }

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0.0),
      child: TextFormField(
        controller: emailTxtCont,
        keyboardType: TextInputType.emailAddress,
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
              border: OutlineInputBorder())),
    );
  }

  Widget _showPassword() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
        controller: passwordTxtCont,
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

  Widget _showButton() {
    return
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: FlatButton(
        onPressed: signInEmail,
        color: Colors.grey[800],
        child: Text('Sign In', style: TextStyle(color: Colors.white),)
      ),
    );
  }

  Widget _showRegister(BuildContext context) {
    return
    Center(
          child: GestureDetector(
            onTap: () {

              Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
            },
          child: Text('Don\'t have account? Register', style: TextStyle(color: Colors.grey[800]),),
      ),
    );
  }
}