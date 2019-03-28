import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'donateDesignAll.dart';

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
          _showTitle(),
          _showSub(),
          _showImage(context),
          _showEventInfo(),
          Divider(),
          _showDesc(),
          _showDonaturText(),
          Divider(),
          _donatorList(),
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
    Image.network(
      item.data['imgUrl'],
      fit: BoxFit.cover,
      height: MediaQuery.of(context).size.width / 1.5,
      width: MediaQuery.of(context).size.width,
    );
  }

  Widget _showEventInfo() {
    var today = item.data['_fl_meta_']['createdDate'];
    String formatter =
        "${today.year.toString()}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}";
    return
    Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.card_giftcard, color: Colors.grey,),
          Padding(padding :EdgeInsets.only(left: 4.0), child: Text(item.data['listUser'].length.toString(), style: TextStyle(color: Colors.grey),),),
          Padding(padding :EdgeInsets.only(left: 4.0), child: Text('donasi', style: TextStyle(color: Colors.grey),),),
          Padding(padding: EdgeInsets.only(left: 16.0), child: Icon(Icons.calendar_today, color: Colors.grey,),),
          Padding(padding :EdgeInsets.only(left: 4.0), child: Text(formatter, style: TextStyle(color: Colors.grey),),),
        ],
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
      ),),
    );
  }

  Widget _showDonaturText() {
    return
    Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text('List donatur :', style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold
      ),),
    );
  }

  Widget _donatorList() {
    // List userList = item.data['listUser'];
    List listUser = [];
    List listOrder = [];
    for (var i = 0; i < item.data['listUser'].length; i++) {
      listUser.add(item.data['listUser'][i]['name']);
      listOrder.add(item.data['listUser'][i]['orderId']);
    }
    return 
      ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: listUser.length,
        itemBuilder: (context, i) {
          return _donatorItem(listUser[i], listOrder[i]);
        },
      );
  }

  Widget _donatorItem(name, orderId) {
    return
    Column(
      children: <Widget>[
        ListTile(
          title: Text(name),
          trailing: Text(orderId),
        ),
        Divider()
      ],
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
            MaterialPageRoute(builder: (context) => DonateDesignAll()));
        },
        child: Text('Join us!, Buy to donate now!', textAlign: TextAlign.center, style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.lime
        ),),
      ),
    );
  }

}