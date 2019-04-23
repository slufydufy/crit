import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'salesDetail.dart';

class SalesMain extends StatefulWidget {
  @override
  PenjualanState createState() => PenjualanState();
}

class PenjualanState extends State<SalesMain> {

  Future _allOrderData;
  String _uid;

  Future fetchAllOrder() async {
    FirebaseUser status = await FirebaseAuth.instance.currentUser();
    _uid = status.uid;
    QuerySnapshot fetchOrder = await Firestore.instance.collection('orderList').where('brandId', isEqualTo: 'br_'+_uid).getDocuments();
    return fetchOrder.documents;
  }

  @override
  void initState() {
    _allOrderData = fetchAllOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Penjualan'),
      ),
      body: FutureBuilder(
        future: _allOrderData,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.length < 1 ) {
            return Center(child: Text('Belum ada order masuk'));
          }
            else {
            return
            ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return
                Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('Order Number'),
                      subtitle: Text(snapshot.data[i].data['orderNumber']),
                      trailing: Text(snapshot.data[i].data['status'], style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SalesDetail(item: snapshot.data[i])));
                      },
                    ),
                    Divider()
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}