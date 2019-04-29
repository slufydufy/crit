import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'confirmPayment.dart';
import 'package:flutter/services.dart';
import 'itemAll.dart';
import 'crud.dart';


class OrderList extends StatefulWidget {
  @override
  OrderListState createState() => OrderListState();
}

class OrderListState extends State<OrderList> {
  BuildContext scafoldContext;

  Future _orderData;
  String _docDelId;
  String _docConfId;
  CrudMethod crudObj = CrudMethod();

  Future fetchOrder() async {
    final user = await FirebaseAuth.instance.currentUser();
    final _uid = user.uid;
    QuerySnapshot fetchOrder = await Firestore.instance.collection('orderList').where('uid', isEqualTo: '$_uid').getDocuments();
    return fetchOrder.documents;
  }

  deleteOrderDialog() {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Order'),
          content: Text('Hapus order ini ?'),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Firestore.instance.collection('orderList').document(_docDelId).delete();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            )
          ],
        );
      },
    );
  }

  confirmOrderDialog() {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Selesai'),
          content: Text('Order telah diterima ?'),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: orderproceed
            )
          ],
        );
      },
    );
  }

  orderproceed() {
      crudObj.confirmPayment(_docConfId, {
        "status" : 'pesanan diterima',
      }).then((result) {
        Navigator.pop(context);
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }).catchError((e) {
        print(e);
      });
  }

  void createSnackBar(String message) {
    final snackBar = SnackBar(content: 
     Text(message, style: TextStyle(fontWeight: FontWeight.bold),),
    backgroundColor: Colors.grey.withOpacity(0.8),
    );
    Scaffold.of(scafoldContext).showSnackBar(snackBar);
  }

  @override
  initState() {
    super.initState();
    _orderData = fetchOrder();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Order'),
      ),
      body: 
      Builder(builder: (BuildContext context) {
      scafoldContext = context;
      return
      FutureBuilder(
      future: _orderData,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.data.length == 0) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: Text('No order found, buy from our local brand now.', textAlign: TextAlign.center,)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ItemAll()));
                        },
                        color: Colors.lime,
                        child: Text('View All Items'),
                      ),
                    ),
                  ),

                ],
              ),
            );
          } else {
          return 
          ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) {
              return 
              Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _showStatus(snapshot.data[i]),
                    _showOrderId(snapshot.data[i]),
                    Divider(),
                    _showItem(snapshot.data[i]),
                    _showPrice(snapshot.data[i]),
                    _showQuantity(snapshot.data[i]),
                    _showTotalPrize(snapshot.data[i]),
                    _showAddInfo(snapshot.data[i]),
                    Divider(),
                    _showConfirmBtn(snapshot.data[i]),
                    _showAwbText(snapshot.data[i]),
                    _showAwb(snapshot.data[i])
                  ],
                ),
              ),
            );

              },
            );
          }
        }
      },
    );
  })
    );
  }

  Widget _showStatus(item) {
    return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 0.0),
              child: Text(
                'Status :', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 0.0),
            child: Text(item.data['status'], style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.lime
                ),
              ),
          ),
        ],
      );
  }

  Widget _showOrderId(item) {
    return 
    Row(
        children: <Widget>[
          Expanded(
                      child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 4.0),
              child: Text('Order Number :', style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey
              ),),
            ),
          ),
          
          Container(
            padding: EdgeInsets.only(top: 8.0, right: 16.0),
            child: Text(item.data['orderNumber'], style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey),
                maxLines: 1,),
          ),
          
        ],
      );
    
  }

  Widget _showItem(item) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: 
      Row(
        children: <Widget>[
          Image.network(item.data['itemImg'],
          height: 50,
          width: 50,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(item.data['itemTitle'], style: TextStyle(
                              fontSize: 16.0,
                            ),
                            maxLines: 2,),
            ),
          )
        ],
      ),
    );
  }

  Widget _showQuantity(item) {
    return Row(
        children: <Widget>[
          Expanded(
              child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 0.0),
              child: Text('Jumlah barang', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 0.0),
            child: Text(item.data['quantity'].toString(), style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
          ),
        ],
      );
  }

  Widget _showPrice(item) {
    return Row(
        children: <Widget>[
          Expanded(
              child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 0.0),
              child: Text('Harga', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 0.0),
            child: Text(item.data['itemPrice'].toString(), style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
          ),
        ],
      );
  }

  Widget _showTotalPrize(item) {
    return Row(
        children: <Widget>[
          Expanded(
                      child: Container(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 0.0),
                child: Text('Harga Total', style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                  ),
                ),
              ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 0.0),
            child: Text(item.data['totalPrice'].toString(), style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
                ),
              ),
          ),
        ],
      );
  }

  Widget _showAddInfo(item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text('Info tambahan :', style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey
                          )),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey)
            ),
            child: 
              Container(
                padding: EdgeInsets.all(8.0),
                child: 
                Text(item.data['addInfo'] ?? "", style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey
                    ),
                    maxLines: 2,
                  ),
              ),
          ),
        ],
      ),
    );
  }

  Widget _showConfirmBtn(item) {
    final _docId = item.documentID;
    _docDelId = _docId;
    if (item.data['status'] != 'menunggu pembayaran') {
      return
      Container(height: 8.0,);
    } else {
      return Container(
      padding: EdgeInsets.only(left: 16.0, bottom: 8.0, top: 0.0),
      child: Row(
        children: <Widget>[
          ButtonTheme(
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmPayment(itemConf: item,)));
                },
                color: Colors.lime,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                child: Text('Konfirmasi Pembayaran', style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.cancel),
            iconSize: 32,
            color: Colors.lime,
            onPressed: deleteOrderDialog,
          ),
          Container(width: 8,)
        ],
      ),
    );
    }
  }

  Widget _showAwbText(item) {
    if (item.data['status'] != 'pesanan dikirim') {
      return Container();
    } else {
      final _docId = item.documentID;
    _docConfId = _docId;
    return
    Row(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
              child: Text(
                'AWB / No Resi:', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
            ),
          Container(width: 16.0,),
          Container(
            padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.lime, width: 2.0)
            ),
            child: GestureDetector(
              child: Text('copy', style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.grey
              ),),
              onTap: () {
                Clipboard.setData(ClipboardData(text: item.data['awb']));
                createSnackBar('AWB / No resi berhasil di copy');
              }
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.check_circle),
            color: Colors.lime,
            iconSize: 32,
            onPressed: confirmOrderDialog
          ),
          Container(width: 8.0,)
        ],
      );
    }
  }
  
  Widget _showAwb(item) {
    if (item.data['status'] != 'pesanan dikirim') {
      return Container();
    } else {
    return
     Container(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
        child: Text(item.data['awb'], style: TextStyle(
              fontSize: 16.0,
              color: Colors.lime
            ),
            maxLines: 2,
          ),
      );
    }
  }

}
