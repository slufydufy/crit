import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'itemDetail.dart';
import 'myHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'orderList.dart';
import 'mainLogin.dart';
import 'storyAll.dart';
import 'profile.dart';
import 'brandAll.dart';

class ItemAll extends StatefulWidget {

  @override
  ItemAllState createState() => ItemAllState();
}

class ItemAllState extends State<ItemAll> {
  Future _itemTopsData;
  Future _itemBottomsData;
  Future _itemAccecoriesData;

  Future fetchItemTops() async {
    QuerySnapshot fetchTopItem = await Firestore.instance.collection('items').where('category', isEqualTo: 'tops').getDocuments();
    return fetchTopItem.documents;
  }

  Future fetchItemBottoms() async {
    QuerySnapshot fetchBotItem = await Firestore.instance.collection('items').where('category', isEqualTo: 'bottoms').getDocuments();
    return fetchBotItem.documents;
  }

  Future fetchItemAccessories() async {
    QuerySnapshot fetchAccItem = await Firestore.instance.collection('items').where('category', isEqualTo: 'accessories').getDocuments();
    return fetchAccItem.documents;
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

  @override
  void initState() {
    super.initState();
    _itemTopsData = fetchItemTops();
    _itemBottomsData = fetchItemBottoms();
    _itemAccecoriesData = fetchItemAccessories();
  }

  @override
  Widget build(BuildContext context) {
    return
    DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: _showDrawer(),
        appBar: AppBar(
          title: Text('All Item'),
          actions: <Widget>[
            SizedBox(
              width: 54.0,
              child: FlatButton(child: Icon(Icons.shopping_cart),
                onPressed: checkLoginOrderAppbar),
            )
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(
                text: 'Tops',
              ),
              Tab(
                text: 'Bottom',
              ),
              Tab(
                text: 'Accecories',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _showTopsItem(),
            _showBottomsItem(),
            _showAccecoriesItem()
          ],
        ),
      ),
    );
  }

  Widget _showTopsItem() {
    return
    FutureBuilder(
      future: _itemTopsData,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return _itemCard(snapshot.data[index]);
                  },
                ),
          );
        }
      },
    );
  }

  Widget _showBottomsItem() {
    return
    FutureBuilder(
      future: _itemBottomsData,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return _itemCard(snapshot.data[index]);
                  },
                ),
          );
        }
      },
    );
  }

  Widget _showAccecoriesItem() {
    return
    FutureBuilder(
      future: _itemAccecoriesData,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return _itemCard(snapshot.data[index]);
                  },
                ),
          );
        }
      },
    );
  }

  Widget _itemCard(DocumentSnapshot snapshot) {
    return FlatButton(
        padding: EdgeInsets.all(0.0),
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => ItemDetail(item: snapshot)));
        },
        child: new Card(
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Image.network(
                snapshot.data['mainImg'],
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.width / 2,
                width: MediaQuery.of(context).size.width / 2
              ),
              Positioned(
                bottom: 0.0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  width: (MediaQuery.of(context).size.width / 2) - 8.0,
                  color: Colors.black.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(snapshot.data['itemName'], maxLines: 1,
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
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
            'All Items',
            style: TextStyle(fontSize: 16.0),
          ),
          leading: Icon(Icons.blur_on),
          onTap: () {
            Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ItemAll()));
              }),
        ListTile(
          title: Text(
            'All Brands',
            style: TextStyle(fontSize: 16.0),
          ),
          leading: Icon(Icons.store_mall_directory),
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
          leading: Icon(Icons.fiber_new),
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

}