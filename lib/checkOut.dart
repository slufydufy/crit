import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'crud.dart';
import 'mainLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class CheckOut extends StatefulWidget {
  final DocumentSnapshot itemCO;
  CheckOut({this.itemCO});

  @override
  CheckOutState createState() => CheckOutState();
}

class CheckOutState extends State<CheckOut> {
  BuildContext scafoldContext;

  String finalSize;
  int finalPrice = 0;
  final quantityTxtCont = TextEditingController();
  final orderNameTxtCont = TextEditingController();
  final orderPhoneTxtCont = TextEditingController();
  final orderAddrTxtCont = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String _uid;
  CrudMethod crudObj = CrudMethod();

  @override
  void dispose() {
    quantityTxtCont.dispose();
    orderNameTxtCont.dispose();
    orderPhoneTxtCont.dispose();
    orderAddrTxtCont.dispose();
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

  checkLogin() async {
    FirebaseUser status = await FirebaseAuth.instance.currentUser();
    if (status == null) {
      dismissLoginDialog(context);
    } else {
      _uid = status.uid;
      submitOrder();
    }
  }

  submitOrder() {
    var today = DateTime.now();
    String formatter =
        "${today.year.toString()}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}";
    var charUid = _uid.substring(0, 3);
    var rng = Random();
    var code = rng.nextInt(9000) + 1000;
    if (finalSize == null) {
      createSnackBar('Pilih ukuran');
    } else if (quantityTxtCont.text.isEmpty || quantityTxtCont.text == '0') {
      createSnackBar('Jumlah minimum 1');
    } else if (_formkey.currentState.validate()) {
      crudObj.addOrder({
        'uid': _uid,
        'itemTitle': widget.itemCO.data['title'],
        'itemPrice': widget.itemCO.data['price'],
        'itemImg': widget.itemCO.data['img'],
        'size': finalSize,
        'quantity': quantityTxtCont.text,
        'name': orderNameTxtCont.text,
        'phone': orderPhoneTxtCont.text,
        'address': orderAddrTxtCont.text,
        'totalPrice': finalPrice,
        'status': 'menunggu pembayaran',
        'orderNumber': formatter + '/' + charUid + '/' + code.toString()
      }).then((result) {
        dismissOrderDialog(context);
      }).catchError((e) {
        print(e);
      });
    }
  }

  dismissOrderDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Status'),
          content: Text(
              'Order berhasil, lakukan konfirmasi pembayaran di menu \"Order Saya\"'),
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

  dismissLoginDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You are not sign in'),
          content: Text('Please sign in to make an order'),
          actions: <Widget>[
            FlatButton(
              child: Text('Sign In'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainLogin()));
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    quantityTxtCont.addListener(() {
      num price = widget.itemCO.data['price'];
      int qty = int.tryParse(quantityTxtCont.text);
      setState(() {
        finalPrice = price * qty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Checkout'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            scafoldContext = context;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      _showItemInfoText(),
                      Divider(),
                      _showItem(),
                      _showFinalSize(),
                      _showQuantity(),
                      _showTotalPrize(),
                      _showBuyerInfoText(),
                      Divider(),
                      _receipentForm()
                    ],
                  ),
                ),
                _showCheckoutButton(context)
              ],
            );
          },
        ));
  }

  Widget _showItemInfoText() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        'Info Barang',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }

  Widget _showItem() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Row(
        children: <Widget>[
          Image.network(
            widget.itemCO.data['img'],
            height: 50,
            width: 50,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.itemCO.data['title'],
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
                maxLines: 2,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
            child: Text(
              'IDR',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 0.0, 16.0),
            child: Text(
              widget.itemCO.data['price'].toString(),
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showFinalSize() {
    // List sizeList = widget.itemCO.data['size'];
    List sizeList = [];
    for (var i = 0; i < widget.itemCO.data['size'].length; i++) {
      sizeList.add(widget.itemCO.data['size'][i]['sizeEach']);
    }
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 0.0),
            child: Text(
              'Ukuran',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
          ),
        ),
        Container(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 0.0),
            child: DropdownButton(
              hint: Text(' Pilih ', style: TextStyle(color: Colors.grey)),
              items: sizeList.map((size) {
                return DropdownMenuItem(
                  child: Text(
                    size,
                    style: TextStyle(color: Colors.grey),
                  ),
                  value: size,
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  finalSize = newVal;
                });
              },
              value: finalSize,
            )),
      ],
    );
  }

  Widget _showQuantity() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
            child: Text(
              'Jumlah barang',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
          ),
        ),
        Container(
            width: 80.0,
            padding: const EdgeInsets.fromLTRB(0.0, .0, 16.0, 16.0),
            child: TextFormField(
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              controller: quantityTxtCont,
              maxLength: 4,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.rtl,
              style: TextStyle(color: Colors.grey),
            )),
      ],
    );
  }

  Widget _showTotalPrize() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 24.0),
            child: Text(
              'Total Harga',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
          child: Text(
            '$finalPrice',
            style: TextStyle(fontSize: 16.0, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _showBuyerInfoText() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        'Info Pengiriman',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }

  Widget _receipentForm() {
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[_showName(), _showMobile(), _showAddress()],
      ),
    );
  }

  Widget _showName() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: TextFormField(
          controller: orderNameTxtCont,
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

  Widget _showMobile() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: TextFormField(
        controller: orderPhoneTxtCont,
        keyboardType: TextInputType.phone,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
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

  Widget _showAddress() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      child: TextFormField(
        controller: orderAddrTxtCont,
        maxLines: 5,
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

  Widget _showCheckoutButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.grey,
        child: Center(
          child: Text(
            'Checkout',
            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      onTap: checkLogin,
    );
  }
}
