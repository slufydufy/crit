import 'package:flutter/material.dart';
import 'checkOut.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemDetail extends StatefulWidget {

  final DocumentSnapshot item; 
  ItemDetail({this.item});

  @override
  ItemDetailState createState() => ItemDetailState();
}

class ItemDetailState extends State<ItemDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                _showImage(context),
                _showTitlePrice(),
                _showTitleDesc(),
                Divider(),
                _showMaterial(),
                _showSize(),
                Divider(),
              ],
            ),
          ),
          _showButton()
        ],
      ),
    );
  }

  Widget _showImage(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.5,
      padding: EdgeInsets.all(8.0),
      child: Image.network(widget.item.data['url']),
    );
  }

  Widget _showTitlePrice() {
    return Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: new Container(child: Text(widget.item.data['title'], style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey,
                        ),
                        maxLines: 2,),),
                ),
                Text(widget.item.data['price'].toString(), style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.lime
                ),
                maxLines: 2,)
              ],
            ),
          );
  }

  Widget _showTitleDesc() {
    return Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Column(
              children: <Widget>[
                Text(widget.item.data['desc'],
                style: TextStyle(
                  color: Colors.grey
                  ),)
              ],
            ),
          );
  }

  Widget _showMaterial() {
    return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 16.0),
              child: Text(
                'Material', style: TextStyle(
                  color: Colors.grey
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
            child: Text(widget.item.data['material'], style: TextStyle(
                  color: Colors.lime
                ),
              ),
          ),
        ],
      );
  }

  Widget _showSize() {
    List sizeList = widget.item.data['size'];
    String sizeAvail = sizeList.join(',');
    return Row(
        children: <Widget>[
          Expanded(
              child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Text(
                'Available Size', style: TextStyle(
                  color: Colors.grey
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 16.0),
            child: Text(sizeAvail, style: TextStyle(
                  color: Colors.lime
                ),
              ),
          ),
        ],
      );
  }

  Widget _showButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: ButtonTheme(
          child: RaisedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOut(itemCO: widget.item,)));
          },
          color: Colors.lime,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          child: Text('Order Now', style: TextStyle(
            color: Colors.white
          ),),
        ),
      ),
    );
  }
}