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
        await ref.collection('donateDesign').limit(8).getDocuments();
    return fetchDesign.documents;
  }

  Future fetchDonateJourney() async {
    QuerySnapshot fetchDesign =
        await ref.collection('donateJourney').limit(3).getDocuments();
    return fetchDesign.documents;
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
    _donateJourneyData =fetchDonateJourney();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Crit')
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
            height: 40.0,
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
                'Profile',
                style: TextStyle(fontSize: 16.0),
              ),
              leading: Icon(Icons.person),
              onTap: checkLoginProfile),
          ListTile(
              title: Text(
                'Order Saya',
                style: TextStyle(fontSize: 16.0),
              ),
              leading: Icon(Icons.add_shopping_cart),
              onTap: checkLoginOrder),
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
              onTap: () {print('buy tp dobatesection');},
            ),
          ],
        ));
  }

  Widget _gridView() {
    return Container(
        padding: EdgeInsets.fromLTRB(4.0, 0.0, 8.0, 4.0),
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
        padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, .0),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(
              'Our Donation Journey',
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
              onTap: () {print('local brand section');},
            ),
          ],
        ));
  }

  Widget _donateJourney() {
    return Container(
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
    return 
    FlatButton(
        padding: EdgeInsets.all(0.0),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DonateJourney(item: snapshot)));
        },
        child:
        Padding(
          padding: EdgeInsets.all(8.0),
          child: 
          // Card(
          //   clipBehavior: Clip.antiAlias,
          //   child: 
            Container(
              // padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    clipBehavior: Clip.antiAlias,
                    color: Colors.white,
                    child: 
                      Image.network(
                        snapshot.data['imgUrl'],
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.width / 1.5,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: 
                    Text(snapshot.data['title'],
                    style: TextStyle(
                      fontSize: 18.0
                    ),),
                  ),
                  
                  // Divider(height: 8.0,)
                ],
              // ),
          ),
            ),
        ),
        );
  }
}
