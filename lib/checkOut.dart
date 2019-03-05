import 'package:flutter/material.dart';
import 'myHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckOut extends StatefulWidget{
  final DocumentSnapshot itemCO; 
  CheckOut({this.itemCO});

  @override
  CheckOutState createState() => CheckOutState();
}

class CheckOutState extends State<CheckOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Column(
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
                _showName(),
                _showMobile(),
                _showAddress(),
              ],
            ),
          ),
          _showCheckoutButton(context)
        ],
      ),
    );
  }

  Widget _showItemInfoText() {
    return Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text('Info Barang', style: TextStyle(
            fontSize: 18.0
          ),),
        );
  }

  Widget _showItem() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: 
      Row(
        children: <Widget>[
          Image.network(
            widget.itemCO.data['url'],
          height: 50,
          width: 50,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.itemCO.data['title'], style: TextStyle(
                              fontSize: 16.0,
                            ),
                            maxLines: 2,),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
            child: Text(widget.itemCO.data['price'].toString(), style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.lime
                ),
              ),
          ),
        ],
      ),
    );
  }

  Widget _showFinalSize() {
    return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 16.0),
              child: Text(
                'Ukuran', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
            child: 
            // DropdownButton()
            Text(
                'XL', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.lime
                ),
              ),
          ),
        ],
      );
  }

  Widget _showQuantity() {
    return Row(
        children: <Widget>[
          Expanded(
              child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Text(
                'Jumlah barang', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 16.0),
            child: Text(
                '2', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.lime
                ),
              ),
          ),
        ],
      );
  }

  Widget _showTotalPrize() {
    return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 16.0),
              child: Text(
                'Total Harga', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
            child: Text(
                '270000', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.lime
                ),
              ),
          ),
        ],
      );
  }

  Widget _showBuyerInfoText() {
    return Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text('Info Pengiriman', style: TextStyle(
            fontSize: 18.0
          ),),
        );
  }

  Widget _showName() {
    return Container(
            // height: 70.0,
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: TextFormField(
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'Nama',
                contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                border: OutlineInputBorder()
                )
            ),
          );
  }

  Widget _showMobile() {
    return Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: TextFormField(
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'Nomor HP',
                contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                border: OutlineInputBorder()
                ),
            ),
          );
  }

  Widget _showAddress() {
    return Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Alamat Pengiriman',
                contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                border: OutlineInputBorder()
                ),
            ),
          );
  }

  Widget _showCheckoutButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: ButtonTheme(
        // height: 40.0,
          child: RaisedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
          },
          color: Colors.lime,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          child: Text('Checkout', style: TextStyle(
            color: Colors.white
          ),),
        ),
      ),
    );
  }
}