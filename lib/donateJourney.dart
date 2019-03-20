import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonateJourney extends StatelessWidget {
  final DocumentSnapshot item;
  DonateJourney({this.item});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate Journey'),
      ),
      body: ListView(
        children: <Widget>[
          _showImage(context),
          _showTitle(),
        ],
      ),
    );
  }

  Widget _showImage(BuildContext context) {
    return
    Image.network(
      item.data['imgUrl'],
      fit: BoxFit.cover,
      height: MediaQuery.of(context).size.width / 1.5,
      width: MediaQuery.of(context).size.width,
    );
  }

  Widget _showTitle() {
    return
    Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Text(item.data['title'], style: TextStyle(
        fontSize: 20.0
      ),),
    );
  }

}