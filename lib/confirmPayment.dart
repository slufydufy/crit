import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'crud.dart';
import 'package:flutter/services.dart';

class ConfirmPayment extends StatefulWidget {
  final DocumentSnapshot itemConf;
  ConfirmPayment({this.itemConf});
  @override
  ConfirmPaymentState createState() => ConfirmPaymentState();
}

class ConfirmPaymentState extends State<ConfirmPayment> {

  final _formConfirmKey = GlobalKey<FormState>();
  final bankTxtCont = TextEditingController();
  final rekTxtCont = TextEditingController();
  final jumlahTxtCont = TextEditingController();
  CrudMethod crudObj = CrudMethod();

  @override
  void dispose() {
    bankTxtCont.dispose();
    rekTxtCont.dispose();
    rekTxtCont.dispose();
    super.dispose();
  }

  confirm() {
    if (_formConfirmKey.currentState.validate()) {
      crudObj.confirmPayment(widget.itemConf.documentID, {
        "status" : 'konfirmasi by admin',
        "bank" : bankTxtCont.text,
        "noRekCust" : rekTxtCont.text,
        "jmlBayar" : jumlahTxtCont.text
      }).then((result) {
        dismissConfirmDialog();
      }).catchError((e) {
        print(e);
      });
    }
  }

  dismissConfirmDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Payment'),
          content: Text('Konfirmasi by admin membutuhkan beberapa saat, silahkan melihat status order anda di menu \"Order Saya\"'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
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
        title: Text('Confirm Payment'),
      ),
      body: ListView(
        children: <Widget>[
          _showOrderId(widget.itemConf),
          Divider(),
          _showItemName(widget.itemConf),
          Divider(),
          _showTotalPrice(widget.itemConf),
          Divider(),
          _showConfirmText(),
          _formConfirm(),
          _showCheckoutButton()
        ],
      ),
    );
  }

  Widget _showOrderId(item) {
    return
    ListTile(
            title: Text('Order Number'),
            subtitle: Text(item.data['orderNumber'].toString()),
          );
  }

  Widget _showItemName(item) {
    return
    ListTile(
            title: Text('Nama Barang'),
            subtitle: Text(item.data['itemTitle']),
          );
  }

  Widget _showTotalPrice(item) {
    return
    ListTile(
            title: Text('Harga Total'),
            subtitle: Text(item.data['totalPrice'].toString()),
          );
  }

  Widget _showConfirmText() {
    return
    Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            child: Text('Konfirmasi:', style: TextStyle(
              fontSize: 16.0
            ),),
          );
  }

  Widget _formConfirm() {
    return
    Form(
      key: _formConfirmKey,
      child: Column(
        children: <Widget>[
          _showBank(),
          _showRek(),
          _showTotalPaid()
        ],
      ),
    );
  }

  Widget _showBank() {
    return
    Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: TextFormField(
        controller: bankTxtCont,
        maxLines: 1,
        validator: (value) {
            if (value.isEmpty) {
              return 'Nama bank belum diisi';
            }
          },
              decoration: InputDecoration(
                contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                labelText: 'Nama Bank',
                border: OutlineInputBorder()
              ),
            ),
          );
  }

  Widget _showRek() {
    return
    Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: TextFormField(
        keyboardType: TextInputType.phone,
        controller: rekTxtCont,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        maxLines: 1,
        validator: (value) {
            if (value.isEmpty) {
              return 'Nomor rekening belum diisi';
            }
          },
              decoration: InputDecoration(
                contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                labelText: 'Nomor Rekening',
                border: OutlineInputBorder()
              ),
            ),
          );
  }

  Widget _showTotalPaid() {
    return
    Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        controller: jumlahTxtCont,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        maxLines: 1,
        validator: (value) {
        if (value.isEmpty) {
        return 'Jumlah transfer belum diisi';
          }
        },
        decoration: InputDecoration(
          contentPadding:
          new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          labelText: 'Jumlah Transfer',
          border: OutlineInputBorder()
              ),
            ),
          );
  }

  Widget _showCheckoutButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0.0),
      child: ButtonTheme(
        child: RaisedButton(
          onPressed: confirm,
          child: Text('Confirm', style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}