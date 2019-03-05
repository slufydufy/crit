import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'itemDetail.dart';
import 'orderList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  Future _bannerData;
  Future _designData;
  
  var ref = Firestore.instance;

  Future fetchBanner() async {
    QuerySnapshot fetchBanner = await ref.collection('banner').getDocuments();
    return fetchBanner.documents;
  }

  Future fetchDonateDesign() async {
    QuerySnapshot fetchDesign = await ref.collection('donateDesign').getDocuments();
    return fetchDesign.documents;
  }

  navigateToDetail(DocumentSnapshot item) {
    Navigator.push(context, 
    MaterialPageRoute(builder: (context) => ItemDetail(item: item)));
  }

  @override
  void initState() {
    super.initState();
    _bannerData = fetchBanner();
    _designData = fetchDonateDesign();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/images/logocr.png',),
      ),
      drawer: _showDrawer(context),
      body: ListView(
        children: <Widget>[
          _showCarousel(context),
          _textProduct(),
          _gridView(context)
          ],
      ),
    );
  }

  Widget _showDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('My Order', style: TextStyle(
              fontSize: 16.0
            ),),
            trailing: Icon(Icons.add_shopping_cart),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderList()));
            }
          ),
          Divider(),
          ListTile(
            title: Text('Article Category', style: TextStyle(
              fontSize: 16.0
            ),),
          ),
          ListTile(
            title: Text('Fashion', style: TextStyle(
              fontSize: 16.0
            ),),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderList()));
            }
          ),
          ListTile(
            title: Text('Fashion', style: TextStyle(
              fontSize: 16.0
            ),),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderList()));
            }
          ),
          ListTile(
            title: Text('Fashion', style: TextStyle(
              fontSize: 16.0
            ),),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderList()));
            }
          ),
          ListTile(
            title: Text('Fashion', style: TextStyle(
              fontSize: 16.0
            ),),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderList()));
            }
          ),
        ],
      ),
    );
  }

  Widget _showCarousel(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return 
    FutureBuilder(
      future: _bannerData,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Loading...'),);
        } else {
          
          return Container(
        height: height * 0.5,
        padding: EdgeInsets.all(8.0),
        child: new Carousel(
          boxFit: BoxFit.cover,
          images: [
            NetworkImage(snapshot.data[0].data['url']),
            NetworkImage(snapshot.data[1].data['url']),
            NetworkImage(snapshot.data[2].data['url']),
            NetworkImage(snapshot.data[3].data['url'])
          ],
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 1500),
          dotSize: 6.0,
          indicatorBgPadding: 15.0,
        ),
      );
        }
      },        
    );
  }

  Widget _textProduct() {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, .0),
      child: Text('Buy and Donate Now', style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      ),
    );
  }

  Widget _gridView(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.0, 0.0, 8.0, 4.0),
      child: 
      FutureBuilder(
        future: _designData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Loading...'),);
          } else {
            return 
            GridView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return 
                _itemCard(context, snapshot.data[index]);
              },);
          }
      }
    ));
  }

  Widget _itemCard(BuildContext context, DocumentSnapshot snapshot) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
        onPressed: () => navigateToDetail(snapshot),
          child: new Card(
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
              child: 
            Stack(
              children: <Widget>[
                Image.network(snapshot.data['url'],
                fit: BoxFit.cover
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
                          Text(snapshot.data['title'], style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                )
              ],
                ),
            ));
  }
}