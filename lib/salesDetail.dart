import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'changeOrderStatus.dart';

class SalesDetail extends StatelessWidget {
  final DocumentSnapshot item;
  SalesDetail({this.item});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Penjualan'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(item.data['status'], style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.redAccent
            ),),
            subtitle: Text('Status Order (Ubah Status Order)'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeOrderStatus(item: item)));
            },
          ),
          ListTile(
            title: Text(item.data['bank'] ?? ""),
            subtitle: Text('Nama Bank'),
          ),
          ListTile(
            title: Text(item.data['noRekCust'] ?? ""),
            subtitle: Text('Nomor Rekening'),
          ),
          ListTile(
            title: Text(item.data['jmlBayar'] ?? ""),
            subtitle: Text('Jumlah Transfer'),
          ),
          ListTile(
            title: Text(item.data['orderNumber'].toString()),
            subtitle: Text('Order Number'),
          ),
          ListTile(
            title: Text(item.data['name']),
            subtitle: Text('Order Contact Name'),
          ),
          ListTile(
            title: Text(item.data['phone']),
            subtitle: Text('Phone'),
          ),
          ListTile(
            title: Text(item.data['address']),
            subtitle: Text('Address'),
          ),
          ListTile(
            title: Text(item.data['itemTitle']),
            subtitle: Text('Item Name'),
          ),
          ListTile(
            title: Text(item.data['quantity']),
            subtitle: Text('Item Quantity'),
          ),
          ListTile(
            title: Text(item.data['addInfo'] ?? ""),
            subtitle: Text('Info Tambahan'),
          ),
          ListTile(
            title: Text(item.data['itemPrice'].toString()),
            subtitle: Text('Item Price'),
          ),
          ListTile(
            title: Text(item.data['totalPrice'].toString()),
            subtitle: Text('Total Price'),
          ),
        ],
      ),
    );
  }


}