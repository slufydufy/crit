import 'package:flutter/material.dart';
import 'checkOut.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_view/photo_view.dart';

class ItemDetail extends StatelessWidget {
  final DocumentSnapshot item;
  ItemDetail({this.item});
    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                _showTitle(),
                _showSub(),
                _showImage(context),
                Divider(),
                _showPrice(),
                Divider(),
                _showMaterial(),
                Divider(),
                _showSize(),
                Divider(),
                _showMoreImageText(),
                _showMoreImage(),
              ],
            ),
          ),
          _showButton(context)
        ],
      ),
    );
  }

  Widget _showTitle() {
    return
    Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: 
      Text(item.data['title'], textAlign: TextAlign.center, style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold
      ),),
    );
  }

  Widget _showSub() {
    return
    Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: 
      Text(item.data['desc'], textAlign: TextAlign.center, style: TextStyle(
        fontSize: 16.0,
        color: Colors.grey,
      ),),
    );
  }

  Widget _showImage(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageFull(item: item)));
        },
        child: Image.network(item.data['url'],
        height: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
        )),
    );
  }

  Widget _showPrice() {
    return
    ListTile(
            title: Text(item.data['price'].toString(), style: TextStyle(
              fontSize: 16.0,
            ),),
            subtitle: Text('Price'),
          );
  }

  Widget _showMaterial() {
    return 
    ListTile(
            title: Text(item.data['material'], style: TextStyle(
              fontSize: 16.0,
            ),),
            subtitle: Text('Material'),
          );
  }

  Widget _showSize() {
    List sizeList = item.data['size'];
    String sizeAvail = sizeList.join(',');
    return 
    ListTile(
            title: Text(sizeAvail, style: TextStyle(
              fontSize: 16.0,
            ),),
            subtitle: Text('Available Size'),
          );
  }

  Widget _showMoreImageText() {
    return
    ListTile(
      title: Text('More Image', style: TextStyle(
        fontSize: 16.0,
      ),)
    );
  }

  Widget _showMoreImage() {
    List urlList = item.data['moreImg'];
    return
    Container(
      padding: EdgeInsets.only(left: 4.0, right: 4.0),
      child: GridView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: urlList.length,
        itemBuilder: (context, i) {
          return 
          _itemCard(context, urlList[i]);
        },),
    );
  }

  Widget _itemCard(BuildContext context, moreUrl) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageFull(item: item)));
        },
        child: new Card(
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
              child: 
              Image.network(moreUrl,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.width / 3
                ),
            ));
  }

  Widget _showButton(BuildContext context) {
    return 
      GestureDetector(
        child: Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.grey,
          child: 
          Center(
            child: 
              Text('Order Now', style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold
                ),
              ),
          ),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOut(itemCO: item)));
          },
    );
  }
}

class ImageFull extends StatelessWidget {
  final DocumentSnapshot item;
  ImageFull({this.item});
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: 
        Stack(
          children: <Widget>[
            GestureDetector(
              child: Center(
                child: Hero(
                  tag: 'imageHero',
                  child: 
                  PhotoView(
                    imageProvider: NetworkImage(item.data['url']), 
                    backgroundDecoration: BoxDecoration(color: Colors.white))
                )
              )
            ),
            Positioned(
              top: 64.0, left: 16.0,
              child: GestureDetector(
                      child: Icon(Icons.arrow_back_ios),
                      onTap: () {
                        Navigator.pop(context);
                      }
                    ),
            )
          ],
        )
      );
  }
}