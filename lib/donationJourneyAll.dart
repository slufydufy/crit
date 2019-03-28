import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'donateJourney.dart';
import 'myHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'orderList.dart';
import 'mainLogin.dart';
import 'profile.dart';
import 'donateDesignAll.dart';

class DonationJourneyAll extends StatefulWidget {

  @override
  DonationJourneyAllState createState() => DonationJourneyAllState();
}

class DonationJourneyAllState extends State<DonationJourneyAll> {

  Future _donateJourneyData;

  Future fetchDonateJourney() async {
    QuerySnapshot fetchJourney =
        await Firestore.instance.collection('fl_content').where('mainCat', isEqualTo: 'story').getDocuments();
    return fetchJourney.documents;
  }

  checkLoginOrder() async {
    FirebaseUser status = await FirebaseAuth.instance.currentUser();
    if (status == null) {
      Navigator.of(context).pop();
      _dismissLoginDialog(context);
    } else {
      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => OrderList()));
    }
  }

  _dismissLoginDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You are not sign in'),
          content: Text('Please sign in to continue'),
          actions: <Widget>[
            FlatButton(
              child: Text('Sign In'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainLogin()));
              },
            )
          ],
        );
      },
    );
  }

  checkLoginProfile() async {
    FirebaseUser status = await FirebaseAuth.instance.currentUser();
    if (status == null) {
      Navigator.of(context).pop();
      _dismissLoginDialog(context);
    } else {
      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Profile()));
    }
  }

  @override
  void initState() {
    super.initState();
    _donateJourneyData = fetchDonateJourney();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Journey'),
      ),
      drawer: _showDrawer(),
      body: FutureBuilder(
        future: _donateJourneyData,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return _donateJourneyCard(snapshot.data[index]);
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget _donateJourneyCard(DocumentSnapshot item) {
    var today = item.data['_fl_meta_']['createdDate'];
    String formatter =
        "${today.year.toString()}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}";
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DonateJourney(item: item)));
      },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              clipBehavior: Clip.antiAlias,
              color: Colors.white,
              child: Image.network(
                item.data['imgUrl'],
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.width / 1.5,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                item.data['title'],
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.card_giftcard, color: Colors.grey,),
                  Padding(padding :EdgeInsets.only(left: 4.0), child: Text(item.data['listUser'].length.toString(), style: TextStyle(color: Colors.grey),),),
                  Padding(padding: EdgeInsets.only(left: 16.0), child: Icon(Icons.calendar_today, color: Colors.grey,),),
                  Padding(padding :EdgeInsets.only(left: 4.0), child: Text(formatter, style: TextStyle(color: Colors.grey),),),
                ],
              ),
            ),
            Divider()
          ],
        ),
    );
  }

  Widget _showDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 32.0,
          ),
        ListTile(
            title: Text(
              'Crit, buy to Donate',
              style: TextStyle(
                fontSize: 22.0,
              ),
            ),
          ),
          Divider(),
          ListTile(
          title: Text(
            'Home',
            style: TextStyle(fontSize: 16.0),
          ),
          leading: Icon(Icons.home),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyHomePage()));
          }),
        ListTile(
          title: Text(
            'Order Saya',
            style: TextStyle(fontSize: 16.0),
          ),
          leading: Icon(Icons.add_shopping_cart),
          onTap: checkLoginOrder),
        ListTile(
          title: Text(
            'Buy to donate design',
            style: TextStyle(fontSize: 16.0),
          ),
          leading: Icon(Icons.hot_tub),
          onTap: () {
            Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DonateDesignAll()));
              }),
        ListTile(
          title: Text(
            'Donation Journey',
            style: TextStyle(fontSize: 16.0),
          ),
          leading: Icon(Icons.card_giftcard),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,MaterialPageRoute(builder: (context) => DonationJourneyAll()));
              }),
        ListTile(
          title: Text(
            'Profile',
            style: TextStyle(fontSize: 16.0),
          ),
          leading: Icon(Icons.person),
          onTap: checkLoginProfile),
        ],
      ),
    );
  }

}