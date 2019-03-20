import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'crud.dart';
import 'awb.dart';

class ChangeOrderStatus extends StatefulWidget {

  final DocumentSnapshot item;
  ChangeOrderStatus({this.item});

  @override
  ChangeOrderStatusState createState() => ChangeOrderStatusState();
}

class ChangeOrderStatusState extends State<ChangeOrderStatus> {

  CrudMethod crudObj = CrudMethod();

  orderproceed() {
      crudObj.confirmPayment(widget.item.documentID, {
        "status" : 'pesanan diproses',
      }).then((result) {
        Navigator.pop(context);
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }).catchError((e) {
        print(e);
      });
    
  }

  dismissProceedDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pembayaran telah dilakukan?'),
          content: Text('Apakah pembayaran telah dipastikan masuk ? tekan OK untuk melanjutkan'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: orderproceed
            )
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    if (widget.item.data['status'] == 'konfirmasi by admin' || widget.item.data['status'] == 'pesanan diproses' || widget.item.data['status'] == 'pesanan dikirim') {
      return Scaffold(
      appBar: AppBar(
        title: Text('Change Order Status'),
      ),
      body: 
      ListView(
        children: <Widget>[
          Container(
            color: Colors.grey[300],
            child: ListTile(
            title: Text('Nomor Rekening'),
            trailing: Text(widget.item.data['noRekCust'] ?? ""),
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: ListTile(
            title: Text('Jumlah Transfer'),
            trailing: Text(widget.item.data['jmlBayar'] ?? ""),
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: ListTile(
            title: Text('Status Saat Ini'),
            trailing: Text(widget.item.data['status'], style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
            child: Text('Ganti status menjadi:', style:TextStyle(
              fontSize: 18.0,
            )),
          ),
          Divider(),
          _showChangetoProceed(widget.item.data['status']),
          _showChangeToDelivery(widget.item)
        ],
      )
    );
    } else {
      return Scaffold(
      appBar: AppBar(
        title: Text('Change Order Status'),
      ),
      body: 
      Center(
        child: Text('Menunggu pembayaran customer'),
      )
    );
    }
  }

  Widget _showChangetoProceed(status) {
    if (status == 'konfirmasi by admin') {
      return
      ListTile(
            title: Text('Pesanan diproses'),
            subtitle: Text('Pembayaran telah dipastikan masuk', style: TextStyle(
              fontWeight: FontWeight.bold,
            ),),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: dismissProceedDialog
          );
    } else {
      return
      Container();
    }
    }

  Widget _showChangeToDelivery(item) {
    if (widget.item.data['status'] == 'pesanan diproses') {
      return
      ListTile(
            title: Text('Pesanan dikirim'),
            subtitle: Text('Pesanan telah dikirim (masukkan AWB)', style: TextStyle(
              fontWeight: FontWeight.bold,
            ),),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AWB(item: item)));
            },
          );
    } else {
      return
      Container();
    }
  }
}