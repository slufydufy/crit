import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adminDetailPage.dart';

class AdminPage extends StatefulWidget {
  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {

  Future _allOrderData;

  Future fetchAllOrder() async {
    QuerySnapshot fetchOrder = await Firestore.instance.collection('orderList').getDocuments();
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
        title: Text('All Order'),
      ),
      body: 
      FutureBuilder(
        future: _allOrderData,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminDetailPage(item: snapshot.data[i])));
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