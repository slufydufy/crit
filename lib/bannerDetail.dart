import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'itemDetail.dart';
import 'itemAll.dart';

class BannerDetail extends StatelessWidget {
  final DocumentSnapshot item;
  BannerDetail({this.item});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRIT'),
      ),
      body: ListView(
        children: <Widget>[
          _showTitle(),
          _showSub(),
          _showImage(context),
          Divider(),
          _showDesc(),
          Divider(),
          _showDonateNowText(context)
        ],
      ),
    );
  }

  Widget _showTitle() {
    return
    Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: 
      Text(item.data['title'], textAlign: TextAlign.center, style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold
      ),),
    );
  }

  Widget _showSub() {
    return
    Padding(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
      child: 
      Text(item.data['subTitle'], textAlign: TextAlign.center, style: TextStyle(
        fontSize: 16.0,
        color: Colors.grey,
      ),),
    );
  }

  Widget _showImage(BuildContext context) {
    return
    FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ImageFull(item: item.data['imgUrl'])));
      },
        child: Image.network(
        item.data['imgUrl'],
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.width / 1.5,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }

  Widget _showDesc() {
    return
    Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: 
      Text(item.data['desc'], style: TextStyle(
        fontSize: 16.0,
      ), textAlign: TextAlign.justify),
    );
  }

  Widget _showDonateNowText(BuildContext context) {
    return
    Padding(
      padding: EdgeInsets.all(16.0),
      child: 
      FlatButton(
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => ItemAll()));
        },
        child: Text('Buy from our local brand now!', textAlign: TextAlign.center, style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.lime
        ),),
      ),
    );
  }
}