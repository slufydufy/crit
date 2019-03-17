import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'crud.dart';

class AWB extends StatefulWidget {

  final DocumentSnapshot item;
  AWB({this.item});

  @override
  AWBState createState() => AWBState();
}

class AWBState extends State<AWB> {

  final _formAwbKey = GlobalKey<FormState>();
  final awbTxtCont = TextEditingController();
  CrudMethod crudObj = CrudMethod();

  awbproceed() {
      crudObj.confirmPayment(widget.item.documentID, {
        "status" : 'pesanan dikirim',
        "awb" : awbTxtCont.text
      }).then((result) {
        Navigator.pop(context);
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }).catchError((e) {
        print(e);
      });
    
  }

  dismissAwbDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Input AWB'),
          content: Text('Apakah AWB / Nomor Resi sudah benar ? tekan OK untuk melanjutkan'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              textColor: Colors.lime,
              onPressed: awbproceed
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input AWB'),
      ),
      body: Column(
          children: <Widget>[
            _formAWB(),
            _showButton()
          ],
        ),
    );
  }

  Widget _formAWB() {
    return
    Form(
      key: _formAwbKey,
      child: Column(
        children: <Widget>[
          _showAwb()
        ],
      ),
    );
  }

  Widget _showAwb() {
    return
    Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 48.0),
        child: TextFormField(
        controller: awbTxtCont,
        maxLines: 1,
        validator: (value) {
            if (value.isEmpty) {
              return 'AWB rekening belum diisi';
            }
          },
              decoration: InputDecoration(
                contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                labelText: 'AWB / Nomor Resi',
                border: OutlineInputBorder()
              ),
            ),
          );
  }

  Widget _showButton() {
    return
    Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: RaisedButton(
        child: Text('Submit'),
        onPressed: dismissAwbDialog,
      ),
    );
  }
}