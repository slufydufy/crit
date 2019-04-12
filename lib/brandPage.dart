import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'brandCreate.dart';

class BrandPage extends StatefulWidget {

  @override
  BrandPageState createState() => BrandPageState();
}

class BrandPageState extends State<BrandPage> {
  Future _brandData;

  Future fetchBrand() async {
    QuerySnapshot brandData =
        await Firestore.instance.collection('brands').where('bUid', isEqualTo: '123').getDocuments();
    return brandData.documents;
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
        title: Text('Brand Page'),
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
}