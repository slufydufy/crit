import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'itemDetail.dart';

class BrandDetail extends StatefulWidget {
  final DocumentSnapshot item;
  BrandDetail({this.item});

  @override
  BrandDetailState createState() => BrandDetailState();
}

class BrandDetailState extends State<BrandDetail> {
  Future _designData;

  Future fetchDonateDesign() async {
    QuerySnapshot fetchDesign = await Firestore.instance.collection('items').where('brandId', isEqualTo: widget.item.data['brandId']).getDocuments();
    return fetchDesign.documents;
  }

  @override
  void initState() {
    super.initState();
    _designData = fetchDonateDesign();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Brand Detail'),
      ),
      body: ListView(
        children: <Widget>[
          _showTitle(),
          _showDesc(),
          _showImage(context),
          Divider(),
          _showContact(),
          Divider(),
          _showPhone(),
          Divider(),
          _brandItemsText(),
          _brandItem(),
        ],
      ),
    );
  }

  Widget _showTitle() {
    return
    Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: 
      Text(widget.item.data['title'], textAlign: TextAlign.center, style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold
      ),
      maxLines: 2,),
    );
  }

  Widget _showDesc() {
    return
    Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: 
      Text(widget.item.data['desc'], textAlign: TextAlign.center, style: TextStyle(
        fontSize: 16.0,
        color: Colors.grey,
      ),
      maxLines: 5,),
    );
  }

  Widget _showImage(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageFull(item: widget.item.data['imgUrl'])));
        },
        child: Image.network(widget.item.data['imgUrl'],
        height: MediaQuery.of(context).size.width / 1.5,
        fit: BoxFit.cover,
        )),
    );
  }

  Widget _showContact() {
    return 
    ListTile(
            title: Text(widget.item.data['email'], style: TextStyle(
              fontSize: 16.0,
            ),),
            subtitle: Text('Email'),
          );
  }

  Widget _showPhone() {
    return 
    ListTile(
            title: Text(widget.item.data['mobile'], style: TextStyle(
              fontSize: 16.0,
            ),),
            subtitle: Text('Phone'),
          );
  }

  Widget _brandItemsText() {
    return Container(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 8.0),
        child: Text(
              'Brand Items',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ));
  }

  Widget _brandItem() {
    return
    FutureBuilder(
        future: _designData,
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
}