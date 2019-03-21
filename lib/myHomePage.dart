import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'itemDetail.dart';
import 'orderList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mainLogin.dart';
import 'crud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';
import 'donateJourney.dart';
import 'donateDesignAll.dart';
import 'donationJourneyAll.dart';

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  Future _bannerData;
  Future _designData;
  Future _donateJourneyData;

  var ref = Firestore.instance;
  CrudMethod crudObj = CrudMethod();

  Future fetchBanner() async {
    QuerySnapshot fetchBanner = await ref.collection('banner').getDocuments();
    return fetchBanner.documents;
  }

  Future fetchDonateDesign() async {
    QuerySnapshot fetchDesign =
        await ref.collection('donateDesign').limit(6).getDocuments();
    return fetchDesign.documents;
  }

  Future fetchDonateJourney() async {
    QuerySnapshot fetchJourney =
        await ref.collection('donateJourney').limit(3).getDocuments();
    return fetchJourney.documents;
  }

  navigateToDetail(DocumentSnapshot item) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ItemDetail(item: item)));
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

  @override
  void initState() {
    super.initState();
    _bannerData = fetchBanner();
    _designData = fetchDonateDesign();
    _donateJourneyData = fetchDonateJourney();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Crit'),
          // Image.asset('assets/images/logocr.png',),
          ),
      drawer: _showDrawer(),
      body: ListView(
        children: <Widget>[
          _showCarousel(),
          _buyToDonateText(),
          _gridView(),
          _donateJourneyText(),
          _donateJourney()
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

  Widget _showCarousel() {
    return FutureBuilder(
      future: _bannerData,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Container(
            height: MediaQuery.of(context).size.height / 2.5,
            child: InkWell(
              onTap: () {
                print('banner clicked');
              },
              child: Carousel(
                boxFit: BoxFit.cover,
                images: [
                  NetworkImage(snapshot.data[0].data['url']),
                  NetworkImage(snapshot.data[1].data['url']),
                  NetworkImage(snapshot.data[2].data['url']),
                  NetworkImage(snapshot.data[3].data['url']),
                  NetworkImage(snapshot.data[4].data['url'])
                ],
                animationCurve: Curves.fastOutSlowIn,
                animationDuration: Duration(milliseconds: 1500),
                dotSize: 6.0,
                indicatorBgPadding: 15.0,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buyToDonateText() {
    return Container(
        padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(
              'Buy to Donate',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            )),
            GestureDetector(
              child: Text('View All',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => DonateDesignAll()));
              },
            ),
          ],
        ));
  }

  Widget _gridView() {
    return Container(
        padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 8.0),
        child: FutureBuilder(
            future: _designData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return _itemCard(snapshot.data[index]);
                  },
                );
              }
            }));
  }

  Widget _itemCard(DocumentSnapshot snapshot) {
    return FlatButton(
        padding: EdgeInsets.all(0.0),
        onPressed: () => navigateToDetail(snapshot),
        child: new Card(
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Image.network(
                snapshot.data['url'],
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.width / 2,
              ),
              Positioned(
                bottom: 0.0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  width: (MediaQuery.of(context).size.width / 2) - 10.0,
                  color: Colors.grey.withOpacity(0.6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(snapshot.data['title'],
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _donateJourneyText() {
    return Container(
        padding: EdgeInsets.fromLTRB(8.0, 32.0, 8.0, .0),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(
              'Donation Journey',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            )),
            GestureDetector(
              child: Text('View All',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(
                  builder: (context) => DonationJourneyAll()));
              },
            ),
          ],
        ));
  }

  Widget _donateJourney() {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: _donateJourneyData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return _donateJourneyCard(snapshot.data[index]);
                  },
                );
              }
            }));
  }

  Widget _donateJourneyCard(DocumentSnapshot snapshot) {
    var today = snapshot.data['pubDate'];
    String formatter =
        "${today.year.toString()}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}";
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DonateJourney(item: snapshot)));
      },
        child: Column(
          children: <Widget>[
            Card(
              clipBehavior: Clip.antiAlias,
              color: Colors.white,
              child: Image.network(
                snapshot.data['imgUrl'],
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.width / 1.5,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                snapshot.data['title'],
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.card_giftcard, color: Colors.grey,),
                  Padding(padding :EdgeInsets.only(left: 4.0), child: Text(snapshot.data['listUser'].length.toString(), style: TextStyle(color: Colors.grey),),),
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
}
