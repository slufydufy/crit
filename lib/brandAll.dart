import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'orderList.dart';
import 'mainLogin.dart';
import 'profile.dart';
import 'myHomePage.dart';
import 'storyAll.dart';
import 'donateDesignAll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BrandAll extends StatefulWidget {
  @override
  BrandAllState createState() => BrandAllState();
}

class BrandAllState extends State<BrandAll> {

  Future _brandData;

  Future fetchBrand() async {
    QuerySnapshot fetchBrandData =
        await Firestore.instance.collection('brands').getDocuments();
    return fetchBrandData.documents;
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
    _brandData = fetchBrand();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Brands'),
        actions: <Widget>[
          SizedBox(
            width: 54.0,
            child: FlatButton(child: Icon(Icons.shopping_cart),
              onPressed: checkLoginOrderAppbar),
          )
        ],
      ),
      drawer: _showDrawer(),
      body: Column(
        children: <Widget>[
          _showBanner(),
          _showBrand(),
        ],
      ),
    );
  }

  Widget _showBanner() {
    return
    Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 2,
      padding: EdgeInsets.all(16.0),
      color: Colors.grey,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Image.network('http://socialzoomfactor.com/wp-content/uploads/2016/01/iStock_000015850715XSmall.jpg', 
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.width / 2.25,
          fit: BoxFit.cover,),
      ));
  }

  Widget _showBrand() {
    return
    FutureBuilder(
      future: _brandData,
      builder:(_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return 
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StaggeredGridView.countBuilder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return brandCard(snapshot.data[index]);
              },
              staggeredTileBuilder: (index) {
                StaggeredTile.fit(2);
              },
            ),
          );
        }
      }
      
    );
  }

  Widget brandCard(DocumentSnapshot item) {
    return FlatButton(
      onPressed: (){
        
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: 
        Image.network(item.data['imgUrl'],
        // width: 100.0,
        // height: 100.0,
        ),
      ),
    );
  }

}