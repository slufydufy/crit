import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'brandBankInfo.dart';
import 'awb.dart';
import 'crud.dart';

class AdminDetailPage extends StatelessWidget {
  final DocumentSnapshot item;
  AdminDetailPage({this.item});

  final CrudMethod crudObj = CrudMethod();

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
          title: Text('Konfirmasi Pembayaran'),
          content: Text('Pembayaran telah dipastikan masuk ?\nKlik OK untuk melanjutkan'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                orderproceed(context);
              }
            )
          ],
        );
      },
    );
  }

  orderproceed(BuildContext context) {
      crudObj.confirmPayment(item.documentID, {
        "status" : 'pesanan diproses',
      }).then((result) {
        Navigator.pop(context);
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }).catchError((e) {
        print(e);
      });
  }

  dismissOnDeliveryDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ubah status menjadi \"diterima\".'),
          content: Text('Nomor AWB telah diterima 2 hari lalu,\nKlik OK untuk melanjutkan'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                orderReceived(context);
              }
            )
          ],
        );
      },
    );
  }

  orderReceived(BuildContext context) {
      crudObj.confirmPayment(item.documentID, {
        "status" : 'pesanan diterima',
      }).then((result) {
        Navigator.pop(context);
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }).catchError((e) {
        print(e);
      });
  }

  dismissSelesaiDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pembayaran telah dilakukan?'),
          content: Text('Pembayaran ke brand telah dilakukan ?\nKlik OK untuk melanjutkan'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                orderSelesai(context);
              }
            )
          ],
        );
      },
    );
  }

  orderSelesai(BuildContext context) {
      crudObj.confirmPayment(item.documentID, {
        "status" : 'selesai',
      }).then((result) {
        Navigator.pop(context);
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }).catchError((e) {
        print(e);
      });
  }

  dismissNoRefDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pembayaran telah dilakukan ke rekening brand.\n\nNomor Referensi Pembayaran:'),
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
        title: Text('Detail Order'),
      ),
      body: 
      ListView(
        children: <Widget>[
          orderStatus(context),
          Container(
            color: Colors.grey,
            child: ListTile(
              title: Text('Brand Bank Info'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BrandBankInfo(brandId: item.data['brandId'])));
              },
            ),
          ),
          showAwb(),
          Padding(
            padding: EdgeInsets.only(top: 16.0, left: 16.0),
            child: Text('Cust Info', style: TextStyle(
              fontSize: 28,
              color: Colors.grey[800]
            ),),
          ),
          ListTile(
            title: Text(item.data['bank'] ?? ""),
            subtitle: Text('Nama Bank'),
          ),
          ListTile(
            title: Text(item.data['accName'] ?? ""),
            subtitle: Text('Nama Account Bank'),
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
      )
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
            dismissSelesaiDialog(context);
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