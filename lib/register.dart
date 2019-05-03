import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'crud.dart';

class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  BuildContext scafoldContext;

  final _formRegKey = GlobalKey<FormState>();
  final nameTxtCont = TextEditingController();
  final emailTxtCont = TextEditingController();
  final passTxtCont = TextEditingController();
  CrudMethod crudObject = CrudMethod();

  @override
  void dispose() {
    nameTxtCont.dispose();
    emailTxtCont.dispose();
    passTxtCont.dispose();
    super.dispose();
  }

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

  registerEmail(email, password) async {
    _loadingDialog(context);
    FirebaseUser user;
    try {
      user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if (user !=null) {
      final user = await FirebaseAuth.instance.currentUser();
      final uid = user.uid;
      crudObject.addUser({
        'uid' :uid,
        'name' : nameTxtCont.text,
        'email' : email,
      }).then((result) {
        Navigator.popUntil(context, ModalRoute.withName('/'));
        user.sendEmailVerification();
      });
      }
    } catch (e) {
      print(e);
      if (e.toString() == 'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)' ) {
        createSnackBar('The email address is already in use by another account');
      } else {
        createSnackBar('SignUp Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: 
      Builder(
        builder: (BuildContext context) {
          scafoldContext = context;
          return
          ListView(
            children: <Widget>[
              Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _showText(),
              _showRegForm(),
              _showButton(context)
            ],
        ),
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
      child: Text('Email Sign Up', style: TextStyle(
        fontSize: 28,
        color: Colors.grey[800]
      ),),
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
        color: Colors.grey[800],
        child: Text('Sign Up', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}