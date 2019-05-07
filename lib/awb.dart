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
      if (awbTxtCont.text.length < 5) {
        Navigator.pop(context);
        dismissAwbWrong();
      } else {
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
              onPressed: awbproceed
            )
          ],
        );
      },
    );
  }

  dismissAwbWrong() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Input AWB'),
          content: Text('Nomor AWB / Nomor Resi yang dimasukkan salah'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              }
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _text(),
            _formAWB(),
            _showButton()
          ],
        ),
    );
  }

  Widget _text() {
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 32.0),
      child: 
      Column(
        children: <Widget>[
          Text('Pembayaran telah dipastikan masuk!', style: TextStyle(
            fontSize: 24.0
          ),),
          Container(height: 16,),
          Text('Silahkan memproses pesanan dan memasukkan AWB / No resi jika telah dikirim.', style: TextStyle(
            fontSize: 16.0
          ),),
          Container(height: 16,),
          Text('Batas proses order sampai dikirim adalah 3 hari, atau order akan dibatalkan otomatis', style: TextStyle(
            fontSize: 14.0
          ),)
        ],
      )
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
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: TextFormField(
        controller: awbTxtCont,
        maxLines: 1,
        validator: (value) {
            if (value.isEmpty) {
              return 'AWB belum diisi';
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
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: RaisedButton(
        child: Text('Submit'),
        onPressed: dismissAwbDialog,
      ),
    );
  }
}