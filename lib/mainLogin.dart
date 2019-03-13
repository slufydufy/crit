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
  final _formLoginkey = GlobalKey<FormState>();
  final passwordTxtCont = TextEditingController();
  final emailTxtCont = TextEditingController();
  CrudMethod crudObj =CrudMethod();


  signInEmail() async {
    FirebaseUser user;
    try {
      user = await FirebaseAuth.instance.
        signInWithEmailAndPassword(email: emailTxtCont.text, password: passwordTxtCont.text);
    } catch (e) {
      print(e.toString());
    } finally {
      if (user != null ) {
        print(user);
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: 
      ListView(
        children: <Widget>[
            _showLogo(context),
            _showSkipText(context),
            _loginForm(),
            _showButton(),
            _showRegister(context)
        ],
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
          Text('Signin', style: TextStyle(
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
        color: Colors.lime.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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