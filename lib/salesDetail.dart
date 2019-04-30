import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'awb.dart';

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
          orderStatus(context),
          showAwb(),
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

  Widget orderStatus(BuildContext context) {
    if (item.data['status'] == 'pesanan diproses') {
      return
      Container(
        color: Colors.lime,
        child: ListTile(
          title: Text(item.data['status'], style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.redAccent
          ),),
          subtitle: Text('Status Order (Klik untuk memassukkan AWB)'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AWB(item: item)));
          },
        ),
      );
    } else {
      return
    Container(
      color: Colors.lime,
      child: ListTile(
        title: Text(item.data['status'], style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.redAccent
        ),),
        subtitle: Text('Status Order (Status Order)'),
      ),
    );
    }
  }

  Widget showAwb() {
    if (item.data['status'] == 'pesanan dikirim' || item.data['status'] == 'pesanan diterima') {
      return
      ListTile(
        title: Text(item.data['awb'].toString()),
        subtitle: Text('AWB / Nomor resi'),
      );
    } else {
      return Container();
    }
  }


}