import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderList extends StatefulWidget {
  @override
  OrderListState createState() => OrderListState();
}

class OrderListState extends State<OrderList> {
  Future _orderData;
  var ref = Firestore.instance;

  Future fetchOrder() async {
    QuerySnapshot fetchOrder = await ref.collection('orderList').getDocuments();
    return fetchOrder.documents;
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
      body: FutureBuilder(
      future: _orderData,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
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
          children: <Widget>[
            _showOrderId(snapshot.data[i]),
            Divider(),
            _showItem(snapshot.data[i]),
            _showPrice(snapshot.data[i]),
            _showFinalSize(snapshot.data[i]),
            _showQuantity(snapshot.data[i]),
            _showTotalPrize(snapshot.data[i]),
            Divider(),
            _showStatus(snapshot.data[i]),
            _showConfirmBtn()
          ],
        ),
      ),
    );

              },
            );
        }
      },
    ),
    );
  }

  Widget _showOrderId(item) {
    return 
    Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: Row(
        children: <Widget>[
          Text('Order Number:', style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey
          ),),
          Container(width: 16.0,),
          Expanded(
            child: Text(item.data['orderNumber'].toString(), style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey),
              maxLines: 1,),
          )
        ],
      ),
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
                  color: Colors.lime
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
                  color: Colors.lime
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
                  color: Colors.lime
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
                child: Text('Total Harga', style: TextStyle(
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
                  color: Colors.lime
                ),
              ),
          ),
        ],
      );
  }

  Widget _showStatus(item) {
    return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 16.0),
              child: Text(
                'Status', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 8.0),
            child: Text(
                'menunggu pembayaran', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.lime
                ),
              ),
          ),
        ],
      );
  }

  Widget _showConfirmBtn() {
    return Container(
      padding: EdgeInsets.only(bottom: 16.0),
      child: ButtonTheme(
        child: RaisedButton(
          onPressed: () {

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
