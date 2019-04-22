import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'itemAll.dart';
import 'itemDetail.dart';

class StoryDetail extends StatelessWidget {
  final DocumentSnapshot item;
  StoryDetail({this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story Detail'),
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

  Widget _showEventInfo() {
    String date = item.data['pubDate'];
    DateTime today = DateTime.parse(date);
    String formatter =
        "${today.year.toString()}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}";
    return
    Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Row(
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(right: 4.0),child: Icon(Icons.star, color: Colors.grey),),
          Padding(padding :EdgeInsets.only(right: 24.0), child: Text(item.data['category'], style: TextStyle(color: Colors.grey),),),
          _giftIcon(item.data['listUser']),
          _listDonator(item.data['listUser']),
          Icon(Icons.calendar_today, color: Colors.grey),
          Padding(padding :EdgeInsets.only(left: 4.0), child: Text(formatter, style: TextStyle(color: Colors.grey),),),
        ],
      ),
    );
  }

  Widget _giftIcon(total) {
    if (total == null) {
      return Container();
      
    } else {
      return
      Icon(Icons.card_giftcard, color: Colors.grey);
    }
  }

  Widget _listDonator(total) {
    if (total == null) {
      return Container();
      
    } else {
      return
      Padding(
        padding :EdgeInsets.only(left: 4.0, right: 24.0),
        child: Text(total.length.toString() ?? "", style: TextStyle(
          color: Colors.grey)));
    }
  }

  Widget _showDesc() {
    return
    Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: 
      Text(item.data['desc'], style: TextStyle(
        fontSize: 16.0,
      ), textAlign: TextAlign.justify,),
    );
  }

  Widget _showDonaturText() {
    if (item.data['listUser'] == null) {
      return Container();
    } else {
    return
    Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text('Donation List', style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold
      ),),
    );
    }
  }

  Widget _donatorList() {
    if (item.data['listUser'] == null) {
      return Container();
    } else {
      List listUser = [];
      List listOrder = [];
      List listDonateImg = [];
      for (var i = 0; i < item.data['listUser'].length; i++) {
        listUser.add(item.data['listUser'][i]['name']);
        listOrder.add(item.data['listUser'][i]['orderId']);
        listDonateImg.add(item.data['listUser'][i]['donateImg']);
    }
      return 
      ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: listUser.length,
        itemBuilder: (context, i) {
          return _donatorItem(context, listUser[i], listOrder[i], listDonateImg[i]);
        },
      );
    }
  }

  Widget _donatorItem(context, name, orderId, donateImg) {
    return
    Column(
      children: <Widget>[
        ListTile(
          title: Text(name),
          trailing: Text(orderId),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ImageFull(item: donateImg)));
          },
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
            MaterialPageRoute(builder: (context) => ItemAll()));
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