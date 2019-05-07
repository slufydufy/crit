import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'awb.dart';

class SalesDetail extends StatelessWidget {
  final DocumentSnapshot item;
  SalesDetail({this.item});

  dismissWaitPaymentDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Menunggu konfirmasi pembayaran dari customer.'),
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

  dismissConfAdminDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi pembayaran dilakukan oleh Admin BrandWash.'),
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

  dismissOnDeliveryDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dalam pengiriman, menunggu konfirmasi diterima.'),
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

  dismissReceivedDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pesanan telah sampai, dalam proses pembayaran oleh Admin'),
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

  dismissNoRefDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pembayaran dilakukan ke bank anda.\nNomor Referensi Pembayaran'),
          content: Text(item.data['orderNumber'], style: TextStyle(
            fontSize: 18,
          ),),
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
        title: Text('Detail Penjualan'),
      ),
      body: ListView(
        children: <Widget>[
          orderStatus(context),
          Padding(
            padding: EdgeInsets.only(top: 16.0, left: 16.0),
            child: Text('Cust Info', style: TextStyle(
              fontSize: 28,
              color: Colors.grey[800]
            ),),
          ),
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
          Divider(),
          Padding(
            padding: EdgeInsets.only(top: 16.0, left: 16.0),
            child: Text('Item Info', style: TextStyle(
              fontSize: 28,
              color: Colors.grey[800]
            ),),
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
    if (item.data['status'] == 'menunggu pembayaran') {
      return
      Container(
        color: Colors.lime,
        child: ListTile(
          title: Text(item.data['status'], style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.redAccent
          ),),
          subtitle: Text('Status Order'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            dismissWaitPaymentDialog(context);
          },
        ),
      );
    } else if (item.data['status'] == 'konfirmasi by admin') {
      return
      Container(
        color: Colors.lime,
        child: ListTile(
          title: Text(item.data['status'], style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.redAccent
          ),),
          subtitle: Text('Status Order'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            dismissConfAdminDialog(context);
          },
        ),
      );
    } else if (item.data['status'] == 'pesanan diproses') {
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
    } else if (item.data['status'] == 'pesanan dikirim') {
      return
      Container(
        color: Colors.lime,
        child: ListTile(
          title: Text(item.data['status'], style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.redAccent
          ),),
          subtitle: Text('Status Order'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            dismissOnDeliveryDialog(context);
          },
        ),
      );
    } else if (item.data['status'] == 'pesanan diterima') {
      return
      Container(
        color: Colors.lime,
        child: ListTile(
          title: Text(item.data['status'], style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.redAccent
          ),),
          subtitle: Text('Status Order'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            dismissReceivedDialog(context);
          },
        ),
      );
    } else if (item.data['status'] == 'selesai') {
      return
      Container(
        color: Colors.lime,
        child: ListTile(
          title: Text(item.data['status'], style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.redAccent
          ),),
          subtitle: Text('Status Order (Lihat No.Ref Transfer)'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            dismissNoRefDialog(context);
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
    if (item.data['status'] == 'pesanan dikirim' || item.data['status'] == 'pesanan diterima' || item.data['status'] == 'selesai') {
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

// Column(
//         children: <Widget>[
//           Center(child: Text('Pembayaran telah dilakukan dengan nomor referensi:'),),
//           Center(child: Text(item.data['orderNumber'], style: TextStyle(
//             fontSize: 18,
//           ),))
//         ],
//       );