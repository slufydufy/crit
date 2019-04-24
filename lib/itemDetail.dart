import 'package:flutter/material.dart';
import 'checkOut.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'brandDetail.dart';

class ItemDetail extends StatefulWidget {
  final DocumentSnapshot item;
  ItemDetail({this.item});

  @override
  ItemDetailState createState() => ItemDetailState();
}

class ItemDetailState extends State<ItemDetail> {
  
  Future _brandData;

  Future fetchBrand() async {
    final String _id = widget.item.data['brandId'];
    QuerySnapshot data = await Firestore.instance.collection('brands').where('brandId', isEqualTo: _id).getDocuments();
    return data.documents;
  }

  @override
  void initState() {
    super.initState();
    _brandData = fetchBrand();
  }

  bool _isFav = true;
  int _favCount = 0;

  void togleFav() {
    setState(() {
      if(_isFav) {
        _isFav = false;
        _favCount += 1;
      } else {
        _isFav = true;
        _favCount -= 1;
      }
    });
  }

  floatLike() {
    return
    Padding(
      padding: const EdgeInsets.only(bottom: 48.0),
      child: FloatingActionButton.extended(
        icon: (_isFav ? Icon(Icons.favorite_border) : Icon(Icons.favorite)),
        // Icon(Icons.favorite_border),
        label: Text(_favCount.toString()),
        onPressed: togleFav,
      ),
    );
  }

  counter() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      floatingActionButton: floatLike(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                _showTitle(),
                _showSub(),
                _showImage(context),
                _showBrandName(),
                Divider(),
                _showPrice(),
                Divider(),
                _showMaterial(),
                Divider(),
                _showAddInfo(),
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
      Text(widget.item.data['itemName'], textAlign: TextAlign.center, style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold
      ),
      maxLines: 2,),
    );
  }

  Widget _showSub() {
    return
    Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: 
      Text(widget.item.data['itemDesc'], textAlign: TextAlign.center, style: TextStyle(
        fontSize: 16.0,
        color: Colors.grey,
      ),
      maxLines: 5),
    );
  }

  Widget _showImage(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0),
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageFull(item: widget.item.data['mainImg'])));
        },
        child: Image.network(widget.item.data['mainImg'],
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
        )),
    );
  }

  Widget _showBrandName() {
    return
    FutureBuilder(
      future: _brandData,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return
          ListTile(
            subtitle: Text('Brand'),
          );
        } else {
          return
          ListTile(
            title: Text(widget.item.data['brandName'].toString(), style: TextStyle(
              fontSize: 16.0,
            ),),
            subtitle: Text('Brand'),
            onTap:  () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BrandDetail(item: snapshot.data[0])));
              },
          );
        }
      },
    );
  }

  Widget _showPrice() {
    return
    ListTile(
      title: Text(widget.item.data['price'].toString(), style: TextStyle(
        fontSize: 16.0,
      ),),
      subtitle: Text('Price'),
    );
  }

  Widget _showMaterial() {
    return 
    ListTile(
            title: Text(widget.item.data['material'], style: TextStyle(
              fontSize: 16.0,
            ),),
            subtitle: Text('Material'),
          );
  }

  Widget _showAddInfo() {
    return 
    ListTile(
            title: Text('Info Tambahan', style: TextStyle(
              fontSize: 16.0,
            ),),
            subtitle: Text(widget.item.data['addInfo'] ?? "",
          )
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
    List moreImgList = [];
      moreImgList.add(widget.item.data['moreImg1'] ?? "");
      moreImgList.add(widget.item.data['moreImg2'] ?? "");
      moreImgList.add(widget.item.data['moreImg3'] ?? "");
          
    return
    Container(
      height: MediaQuery.of(context).size.width / 1.5,
      child: 
      Swiper(
        itemBuilder: (context, i) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Image.network(moreImgList[i],fit: BoxFit.cover,));
        },
        itemCount: moreImgList.length,
        pagination: SwiperPagination(),
        onTap: (i) {
            Navigator.push(context,MaterialPageRoute(builder: (context) => ImageFull(item: moreImgList[i],)));
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOut(itemCO: widget.item)));
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
                width: 32.0,
                height: 32.0,
                child: FloatingActionButton(
                  elevation: 0.0,
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