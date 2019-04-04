import 'package:flutter/material.dart';
import 'myHomePage.dart';
import 'register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'crud.dart';

class MainLogin extends StatefulWidget {

  @override
  _MainLoginState createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
  BuildContext scafoldContext;

  final _formLoginkey = GlobalKey<FormState>();
  final passwordTxtCont = TextEditingController();
  final emailTxtCont = TextEditingController();
  CrudMethod crudObj =CrudMethod();

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
        CircularProgressIndicator();
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }
    }
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: 
      Builder(
        builder: (BuildContext context) {
          scafoldContext = context;
          return
            ListView(
          children: <Widget>[
              _showLogo(context),
              _showSkipText(context),
              _loginForm(),
              _showButton(),
              _showRegister(context)
          ],
        );
        },
      ),
    );
  }

  Widget _showLogo(BuildContext context) {
    return Image.asset('assets/images/loginimg.png',
    height: MediaQuery.of(context).size.height / 2,
    fit: BoxFit.cover,
    );
  }

  Widget _showSkipText(BuildContext context) {
    return 
    Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        children: <Widget>[
          Text('Sign in', style: TextStyle(
            color: Colors.black45,
            fontSize: 22
          )),
          Spacer(),
          GestureDetector(
            onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
          },
          child: Text('Skip', style: TextStyle(
            color: Colors.black45,
            fontSize: 12
          )))
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Form(
        key: _formLoginkey,
        child: Column(
          children: <Widget>[
            _showEmail(),
            _showPassword(),
          ],
        ),
      ),
    );
  }

  Widget _showEmail() {
    return Container(
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
              border: OutlineInputBorder())),
    );
  }

  Widget _showPassword() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
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
      padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
      child: RaisedButton(
        onPressed: signInEmail,
        color: Colors.grey[800],
        child: Text('Login', style: TextStyle(color: Colors.white),),
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
          child: Text('Don\'t have account? Register', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}