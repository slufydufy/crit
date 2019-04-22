import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'changeOrderStatus.dart';

class AdminDetailPage extends StatefulWidget {

  final DocumentSnapshot item;
  AdminDetailPage({this.item});

  @override
  AdminDetailPageState createState() => AdminDetailPageState();
}

class AdminDetailPageState extends State<AdminDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Order'),
      ),
      body: 
      ListView(
        children: <Widget>[
          ListTile(
            title: Text('Order Status (Edit)'),
            subtitle: Text(widget.item.data['status'], style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.redAccent
            ),),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeOrderStatus(item: widget.item)));
            },
          ),
          ListTile(
            title: Text('Nomor Rekening'),
            subtitle: Text(widget.item.data['noRekCust'] ?? ""),
          ),
          ListTile(
            title: Text('Jumlah Transfer'),
            subtitle: Text(widget.item.data['jmlBayar'] ?? ""),
          ),
          ListTile(
            title: Text('Order Number'),
            subtitle: Text(widget.item.data['orderNumber'].toString()),
          ),
          ListTile(
            title: Text('Contact Name'),
            subtitle: Text(widget.item.data['name']),
          ),
          ListTile(
            title: Text('Contact Phone'),
            subtitle: Text(widget.item.data['phone']),
          ),
          ListTile(
            title: Text('Contact Address'),
            subtitle: Text(widget.item.data['address']),
          ),
          ListTile(
            title: Text('Item Name'),
            subtitle: Text(widget.item.data['itemTitle']),
          ),
          ListTile(
            title: Text('Item Quantity'),
            subtitle: Text(widget.item.data['quantity']),
          ),
          ListTile(
            title: Text('Info Tambahan'),
            subtitle: Text(widget.item.data['addInfo'] ?? ""),
          ),
          ListTile(
            title: Text('Item Price'),
            subtitle: Text(widget.item.data['itemPrice'].toString()),
          ),
          ListTile(
            title: Text('Total Price'),
            subtitle: Text(widget.item.data['totalPrice'].toString()),
          ),
        ],
      )
    );
  }
}