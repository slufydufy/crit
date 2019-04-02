import 'package:flutter/material.dart';
import 'checkOut.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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
                Divider(height: 8.0,),
                _showPrice(),
                Divider(),
                _showMaterial(),
                Divider(),
                _showSize(),
                Divider(),
                _showMoreImageText(),
                _showMoreImage(context),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageFull(item: item.data['img'])));
        },
        child: Image.network(item.data['img'],
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
    List sizeList = [];
    for (var i = 0; i < item.data['size'].length; i++) {
      sizeList.add(item.data['size'][i]['sizeEach']);
    }
    String sizeAvail = sizeList.join(', ');

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

  Widget _showMoreImage(BuildContext context) {
    return
    Container(
      height: MediaQuery.of(context).size.width / 1.5,
      child: 
      Swiper(
        itemBuilder: (context, i) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Image.network(item.data['moreImg'][i]['imgUrl'],fit: BoxFit.cover,));
        },
        itemCount: item.data['moreImg'].length,
        pagination: SwiperPagination(),
        onTap: (i) {
            Navigator.push(context,MaterialPageRoute(builder: (context) => ImageFull(item: item.data['moreImg'][i]['imgUrl'],)));
        },
        viewportFraction: 0.7,
        scale: 0.8,
      )
    );
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
  final String item;
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
                    imageProvider: NetworkImage(item),
                    initialScale: 1.5,
                    backgroundDecoration: BoxDecoration(color: Colors.white))
                )
              )
            ),
            Positioned(
              top: 64.0, left: 16.0,
              child: 
              Container(
                width: 30.0,
                height: 30.0,
                child: FloatingActionButton(
                  child: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            )
          ],
        )
      );
  }
}