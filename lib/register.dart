import 'package:flutter/material.dart';
import 'myHomePage.dart';

class Register extends StatelessWidget {

  final _formRegKey = GlobalKey<FormState>();
  final nameTxtCont = TextEditingController();
  final emailTxtCont = TextEditingController();
  final passTxtCont = TextEditingController();

  // _registerAction(BuildContext context) {
  //   if (_formRegkey.currentState.validate()) {
  //           Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
  //         } 
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
      backgroundColor: Colors.grey[600],
    );
  }

  Widget _showRegForm() {
    return Form(
      key: _formRegKey,
      child: Column(
        children: <Widget>[
          _showName(),
          _showEmail(),
          _showPassword()
        ],
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
              return 'Nama belum diisi';
            }
          },
          decoration: InputDecoration(
              labelText: 'Nama',
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
              return 'Nomor HP belum diisi';
            }
          },
        decoration: InputDecoration(
            labelText: 'Nomor HP',
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
        validator: (value) {
            if (value.isEmpty) {
              return 'Alamat belum diisi';
            }
          },
        decoration: InputDecoration(
            labelText: 'Alamat Pengiriman',
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border: OutlineInputBorder()),
      ),
    );
  }
  Widget _showButton(BuildContext context) {
    return
    Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
      child: RaisedButton(
        onPressed: () {},
        // _registerAction(context),
        color: Colors.lime.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Text('Register', style: TextStyle(color: Colors.white),),
      ),
    );
  }

}