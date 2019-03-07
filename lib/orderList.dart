import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
      ),
      body: _listBuilder(context),
    );
  }

  Widget _listBuilder(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, i) {
        return OrderCard();
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: Card(
        child: Column(
          children: <Widget>[
            _showOrderId(),
            Divider(),
            _showItem(),
            _showPrice(),
            _showFinalSize(),
            _showQuantity(),
            _showTotalPrize(),
            Divider(),
            _showStatus()
          ],
        ),
      ),
    );
  }

  Widget _showOrderId() {
    return 
    Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: Row(
        children: <Widget>[
          Text('Order Number:', style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey
          ),),
          Container(width: 16.0,),
          Text('20190222-101', style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey
          ),)
        ],
      ),
    );
  }

  Widget _showItem() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: 
      Row(
        children: <Widget>[
          Image.network('https://www.redwolf.in/image/cache/catalog/mens-t-shirts/breaking-bad-official-heisenberg-t-shirt-india-438x438.jpg',
          height: 50,
          width: 50,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Mr.Crit in full face', style: TextStyle(
                              fontSize: 16.0,
                            ),
                            maxLines: 2,),
            ),
          )
        ],
      ),
    );
  }

  Widget _showFinalSize() {
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
            child: Text(
                'XL', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.lime
                ),
              ),
          ),
        ],
      );
  }

  Widget _showQuantity() {
    return Row(
        children: <Widget>[
          Expanded(
              child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 0.0),
              child: Text(
                'Jumlah barang', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 0.0),
            child: Text(
                '2', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.lime
                ),
              ),
          ),
        ],
      );
  }

  Widget _showPrice() {
    return Row(
        children: <Widget>[
          Expanded(
              child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 0.0),
              child: Text(
                'Harga', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 0.0),
            child: Text(
                '135000', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.lime
                ),
              ),
          ),
        ],
      );
  }

  Widget _showTotalPrize() {
    return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 0.0),
              child: Text(
                'Total Harga', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 0.0),
            child: Text(
                '270000', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.lime
                ),
              ),
          ),
        ],
      );
  }

  Widget _showStatus() {
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
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 16.0),
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

}