import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'confirmPayment.dart';
import 'package:flutter/services.dart';

class OrderList extends StatefulWidget {
  @override
  OrderListState createState() => OrderListState();
}

class OrderListState extends State<OrderList> {
  BuildContext scafoldContext;

  Future _orderData;
  var ref = Firestore.instance;

  Future fetchOrder() async {
    final user = await FirebaseAuth.instance.currentUser();
    final _uid = user.uid;
    QuerySnapshot fetchOrder = await ref.collection('orderList').where('uid', isEqualTo: '$_uid').getDocuments();
    return fetchOrder.documents;
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
        title: Text('Order List'),
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
            return Center(child: Text('You\'re not order any item yet, buy to donate now.'));
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
                    _showFinalSize(snapshot.data[i]),
                    _showQuantity(snapshot.data[i]),
                    _showTotalPrize(snapshot.data[i]),
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

  Widget _showFinalSize(item) {
    return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 0.0),
              child: Text(
                'Ukuran', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 0.0),
            child: Text(item.data['size'], style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
          ),
        ],
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
                    color: Colors.grey
                  ),
                ),
              ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 0.0),
            child: Text(item.data['totalPrice'].toString(), style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
          ),
        ],
      );
  }

  Widget _showConfirmBtn(item) {
    if (item.data['status'] != 'menunggu pembayaran') {
      return
      Container(height: 8.0,);
    } else {
      return Container(
      padding: EdgeInsets.only(left: 16.0, bottom: 8.0, top: 0.0),
      child: ButtonTheme(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmPayment(itemConf: item,)));
          },
          color: Colors.lime,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Text('Konfirmasi', style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
    }
  }

  Widget _showAwbText(item) {
    if (item.data['status'] != 'pesanan dikirim') {
      return Container();
    } else {
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
          ),
      );
    }
  }

}
