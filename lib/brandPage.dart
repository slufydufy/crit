import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'brandCreate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'addItem.dart';
import 'brandEdit.dart';

class BrandPage extends StatefulWidget {

  @override
  BrandPageState createState() => BrandPageState();
}

class BrandPageState extends State<BrandPage> {
  Future _brandData;
  Future _itemData;

  Future fetchBrand() async {
    String _uid;
    FirebaseUser status = await FirebaseAuth.instance.currentUser();
    _uid = status.uid;
    QuerySnapshot brandData =
        await Firestore.instance.collection('brands').where('brandId', isEqualTo: 'br_' + _uid).getDocuments();
    return brandData.documents;
  }

  Future fetchItems() async {
    String _uid;
    FirebaseUser status = await FirebaseAuth.instance.currentUser();
    _uid = status.uid;
    QuerySnapshot fetchItem =
        await Firestore.instance.collection('items').where('brandId', isEqualTo: 'br_' + _uid).getDocuments();
    return fetchItem.documents;
  }

  @override
  void initState() {
    super.initState();
    _brandData = fetchBrand();
    _itemData = fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brand Page'),
        actions: <Widget>[
          SizedBox(
            width: 60.0,
            child: FlatButton(child: Icon(Icons.edit),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => BrandEdit(item: _brandData,)));
              }
              ),
          )
        ],
      ),
      body: FutureBuilder(
        future: _brandData,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data.length < 1) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('You are currently dont own any brand, Create your brand now!', textAlign: TextAlign.center,),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BrandCreate()));
                    },
                    color: Colors.lime,
                    child: Text('Create Brand'),
                  ),
                ],
              ),
            );
          } else {
            return ListView(
              children: <Widget>[
                _showBrandTitle(snapshot.data[0].data['title']),
                _showBrandDesc(snapshot.data[0].data['desc']),
                _showBrandImg(snapshot.data[0].data['imgUrl']),
                _showBrandEmail(snapshot.data[0].data['email']),
                _showBrandPhone(snapshot.data[0].data['mobile']),
                _showItems(),
                _showAddItem(snapshot.data[0].data['title']),
                Divider(),
                _gridView()
              ],
            );
          }
        },
      )
    );
  }

  Widget _showBrandTitle(item) {
    return
    ListTile(
      title: Text(item),
      subtitle: Text('Brand Name'),
    );
  }

  Widget _showBrandDesc(item) {
    return
    ListTile(
      title: Text(item, maxLines: 2,),
      subtitle: Text('Brand Description'),
    );
  }

  Widget _showBrandImg(item) {
    return
    ListTile(
      title: Text('Image Theme'),
      subtitle: Text('Brand Image Theme'),
      trailing: Image.network(item,
        height: 50,
        width: 50,),
    );
  }

  Widget _showBrandEmail(item) {
    return
    ListTile(
      title: Text(item),
      subtitle: Text('Brand Email'),
    );
  }

  Widget _showBrandPhone(item) {
    return
    ListTile(
      title: Text(item),
      subtitle: Text('Phone'),
    );
  }

  Widget _showItems() {
    return Container(
      color: Colors.grey,
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
      child: Text(
        'My Items',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _showAddItem(brandName) {
    return
    ListTile(
      title: Text('Add Item'),
      subtitle: Text('Add item to your brand page'),
      trailing: Icon(Icons.add_circle),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddItem(brandName: brandName,)));
      },
    );
  }

  Widget _gridView() {
    return Container(
        padding: EdgeInsets.fromLTRB(4.0, 16.0, 4.0, 16.0),
        child: FutureBuilder(
            future: _itemData,
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
        onPressed: () {},
        child: new Card(
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Image.network(
                snapshot.data['mainImg'],
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
                      Text(snapshot.data['itemName'], maxLines: 1, textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}