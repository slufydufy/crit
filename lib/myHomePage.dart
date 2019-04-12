import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'itemDetail.dart';
import 'orderList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mainLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';
import 'storyDetail.dart';
import 'donateDesignAll.dart';
import 'storyAll.dart';
import 'bannerDetail.dart';
import 'brandAll.dart';
import 'brandDetail.dart';

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  Future _bannerData;
  Future _designData;
  Future _brandData;
  Future _storyData;

  var ref = Firestore.instance;

  Future fetchBanner() async {
    QuerySnapshot fetchBanner = await ref.collection('fl_content').where('mainCat', isEqualTo: 'banner').getDocuments();
    return fetchBanner.documents;
  }

  Future fetchDonateDesign() async {
    QuerySnapshot fetchDesign =
        await ref.collection('fl_content').where('mainCat', isEqualTo: 'design').limit(6).getDocuments();
    return fetchDesign.documents;
  }

  Future fetchBrand() async {
    QuerySnapshot fetchBrandData = await ref.collection('brands').limit(6).getDocuments();
    return fetchBrandData.documents;
  }

  Future fetchStory() async {
    QuerySnapshot fetchJourney =
        await ref.collection('fl_content').where('mainCat', isEqualTo: 'story').limit(6).getDocuments();
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

  checkLoginOrderAppbar() async {
    FirebaseUser status = await FirebaseAuth.instance.currentUser();
    if (status == null) {
      _dismissLoginDialog(context);
    } else {
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

  Widget _showDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.grey,
            height: MediaQuery.of(context).size.width / 4.5,
          ),
        ListTile(
            title: Text(
              'Crit, buy to Donate',
              style: TextStyle(
                fontSize: 22.0,
              ),
            ),
          ),
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
          leading: Icon(Icons.shopping_cart),
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
            'All Brands',
            style: TextStyle(fontSize: 16.0),
          ),
          leading: Icon(Icons.dashboard),
          onTap: () {
            Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BrandAll()));
              }),      
        ListTile(
          title: Text(
            'All Story',
            style: TextStyle(fontSize: 16.0),
          ),
          leading: Icon(Icons.card_giftcard),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,MaterialPageRoute(builder: (context) => StoryAll()));
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

  @override
  void initState() {
    super.initState();
    _bannerData = fetchBanner();
    _designData = fetchDonateDesign();
    _brandData = fetchBrand();
    _storyData = fetchStory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CRIT'),
        actions: <Widget>[
          SizedBox(
            width: 54.0,
            child: FlatButton(child: Icon(Icons.shopping_cart),
              onPressed: checkLoginOrderAppbar),
          )
        ],
          // Image.asset('assets/images/logocr.png',),
          ),
      drawer: _showDrawer(),
      body: ListView(
        children: <Widget>[
          _showCarousel(),
          _buyToDonateText(),
          _gridView(),
          _brands(),
          _storyText(),
          _story()
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
            height: MediaQuery.of(context).size.width / 1.2,
            child: 
            Swiper(
              itemBuilder: (context, i) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(snapshot.data[i].data['imgUrl'],fit: BoxFit.cover,));
              },
              itemCount: snapshot.data.length,
              duration: 500,
              autoplay: true,
              pagination: SwiperPagination(),
              onTap: (i) {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => BannerDetail(item: snapshot.data[i],)));
              },
              itemWidth: MediaQuery.of(context).size.width / 1.25,
              layout: SwiperLayout.STACK,
            )
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
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            )),
            GestureDetector(
              child: Text('View All',
                  style: TextStyle(
                    color: Colors.grey,
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
        padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 16.0),
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
                      crossAxisCount: 3),
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
                snapshot.data['img'],
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.width / 3,
                width: MediaQuery.of(context).size.width / 3,
              ),
              Positioned(
                bottom: 0.0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  width: (MediaQuery.of(context).size.width / 3) - 10.0,
                  color: Colors.black.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(snapshot.data['title'], maxLines: 1, textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _brandText() {
    return Container(
      color: Colors.grey,
        padding: EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(
              'Local Brand',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            )),
            GestureDetector(
              child: Text('View All',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(
                  builder: (context) => BrandAll()));
              },
            ),
          ],
        ));
  }

  Widget _brands() {
    return 
    Container(
      color: Colors.grey,
      child: Column(
        children: <Widget>[
          _brandText(),
          Container(
            color: Colors.grey,
            height: MediaQuery.of(context).size.width / 1.7,
            padding: EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: _brandData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                      );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return 
                      brandCard(snapshot.data[i]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget brandCard(DocumentSnapshot snapshot) {
    return FlatButton(
            padding: EdgeInsets.all(0.0),
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => BrandDetail(item: snapshot)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(snapshot.data['imgUrl'],
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.width / 2.25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(snapshot.data['title'], style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black
                  )),
                )
              ],
            ),
          );
  }

  Widget _storyText() {
    return Container(
        padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(
              'Story',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            )),
            GestureDetector(
              child: Text('View All',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  )),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(
                  builder: (context) => StoryAll()));
              },
            ),
          ],
        ));
  }

  Widget _story() {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: _storyData,
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
                    return _storyCard(snapshot.data[index]);
                  },
                );
              }
            }));
  }

  Widget _storyCard(DocumentSnapshot snapshot) {
    String date = snapshot.data['pubDate'];
    DateTime today = DateTime.parse(date);
    String formatter =
        "${today.year.toString()}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}";
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoryDetail(item: snapshot)));
      },
        child: Card(
              clipBehavior: Clip.antiAlias,
              color: Colors.white,
              child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                    snapshot.data['imgUrl'],
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.width / 1.75,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data['title'],
                      style: TextStyle(fontSize: 18.0),
                      maxLines: 2,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                  Padding(padding: const EdgeInsets.only(right: 4.0),child: Icon(Icons.lightbulb_outline, color: Colors.grey),),
                  Padding(padding :EdgeInsets.only(right: 24.0), child: Text(snapshot.data['category'], style: TextStyle(color: Colors.grey),),),
                  _giftIcon(snapshot.data['listUser']),
                  _listDonator(snapshot.data['listUser']),
                  Icon(Icons.calendar_today, color: Colors.grey),
                  Padding(padding :EdgeInsets.only(left: 4.0), child: Text(formatter, style: TextStyle(color: Colors.grey),),),
                ],
              ),
            ),
                ],
              ),
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
}
