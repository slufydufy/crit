import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'storyDetail.dart';
import 'myHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'orderList.dart';
import 'mainLogin.dart';
import 'profile.dart';
import 'itemAll.dart';
import 'brandAll.dart';

class StoryAll extends StatefulWidget {

  @override
  StoryAllAllState createState() => StoryAllAllState();
}

class StoryAllAllState extends State<StoryAll> {

  Future _storyData;

  Future fetchStory() async {
    QuerySnapshot storyData =
        await Firestore.instance.collection('fl_content').where('mainCat', isEqualTo: 'story').getDocuments();
    return storyData.documents;
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
              child: Text('SIGN IN'),
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
    _storyData = fetchStory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Story'),
        actions: <Widget>[
          SizedBox(
            width: 54.0,
            child: FlatButton(child: Icon(Icons.shopping_cart),
              onPressed: checkLoginOrderAppbar),
          )
        ],
      ),
      drawer: _showDrawer(),
      body: FutureBuilder(
        future: _storyData,
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
    String date = item.data['pubDate'];
    DateTime today = DateTime.parse(date);
    String formatter =
        "${today.year.toString()}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}";
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoryDetail(item: item)));
      },
        child: Card(
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                    item.data['imgUrl'],
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.width / 1.75,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Padding(
                  padding: const EdgeInsets.all(8.0),
                    child: Text(
                        item.data['title'],
                        style: TextStyle(fontSize: 18.0),
                        maxLines: 2,
                        ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Padding(padding: const EdgeInsets.only(right: 4.0),child: Icon(Icons.lightbulb_outline, color: Colors.grey),),
                  Padding(padding :EdgeInsets.only(right: 24.0), child: Text(item.data['category'], style: TextStyle(color: Colors.grey),),),
                  _giftIcon(item.data['listUser']),
                  _listDonator(item.data['listUser']),
                  Icon(Icons.calendar_today, color: Colors.grey),
                  Padding(padding :EdgeInsets.only(left: 4.0), child: Text(formatter, style: TextStyle(color: Colors.grey),),)
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

  Widget _showDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.grey,
            height: MediaQuery.of(context).size.width / 2,
            child: Center(child: Text('BRANDWASH', style: TextStyle(
              fontSize: 32, 
              color: Colors.white, 
              fontWeight: FontWeight.bold),)),
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
          onTap: checkLoginProfile
        ),
        ],
      ),
    );
  }
}