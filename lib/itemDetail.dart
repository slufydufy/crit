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
                _showImage(context),
                _showTitlePrice(),
                _showTitleDesc(),
                Divider(),
                _showMaterial(),
                _showSize(),
                Divider(),
                _showMoreImage(),
              ],
            ),
          ),
          _showButton(context)
        ],
      ),
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

  Widget _showMoreImage() {
    List urlList = item.data['moreImg'];
    return
    Container(
      padding: EdgeInsets.fromLTRB(6.0, 0.0, 4.0, 6.0),
      child: GridView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
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
                width: MediaQuery.of(context).size.width / 3,
                ),
            ));
  }

  Widget _showTitlePrice() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: new Container(
              child: Text(
                item.data['title'],
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                ),
                maxLines: 2,
              ),
            ),
          ),
          Text(
            item.data['price'].toString(),
            style: TextStyle(fontSize: 20.0, color: Colors.lime),
            maxLines: 2,
          )
        ],
      ),
    );
  }

  Widget _showTitleDesc() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Column(
        children: <Widget>[
          Text(
            item.data['desc'],
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }

  Widget _showMaterial() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 16.0),
            child: Text(
              'Material',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
          child: Text(
            item.data['material'],
            style: TextStyle(color: Colors.lime),
          ),
        ),
      ],
    );
  }

  Widget _showSize() {
    List sizeList = item.data['size'];
    String sizeAvail = sizeList.join(',');
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: Text(
              'Available Size',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 16.0),
          child: Text(
            sizeAvail,
            style: TextStyle(color: Colors.lime),
          ),
        ),
      ],
    );
  }

  Widget _showButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: ButtonTheme(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOut(itemCO: item)));
          },
          color: Colors.lime,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Text('Order Now', style: TextStyle(color: Colors.white),
          ),
        ),
      ),
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
                  child: PhotoView(
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