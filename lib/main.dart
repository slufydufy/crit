import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(new MyApp());
    });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Crit')),
      ),
      body: ListView(
        children: <Widget>[
          _showCarousel(context),
          _textProduct(),
          _gridView(context)
          ],
      ),
    );
  }

  Widget _showCarousel(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.3,
      padding: EdgeInsets.all(8.0),
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          NetworkImage(
              'https://static.thefancydeal.com/uploads/edd/2017/08/buy-tshirt-design.jpg'),
          NetworkImage(
              'https://image.dhgate.com/0x0/f2/albu/g6/M00/74/9F/rBVaR1oySymAMz2TAAM9Nf6_oQA427.jpg'),
          NetworkImage(
              'https://static.thefancydeal.com/uploads/edd/2018/01/Fearless-buy-t-shirt-design.jpg'),
          NetworkImage(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQm0BBJPR09Bj8Ft_TDxbJqqSpb2qBrJEC9NDGq2wfrN-0aHnZo')
        ],
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1500),
        dotSize: 6.0,
        indicatorBgPadding: 15.0,
      ),
    );
  }

  Widget _textProduct() {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, .0),
      child: Text('Buy and Donate Now', style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      ),
    );
  }

  Widget _gridView(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.0, 0.0, 8.0, 4.0),
      child: GridView.count(
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.width / 0.7),
          physics: ScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          children: List.generate(4, (index) {
            return _itemCard(context);
          })),
    );
  }

  Widget _itemCard(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.all(0.0),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ItemDetail()));
        },
        child: new Card(
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: Column(
              
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Image.network(
                    'https://www.redwolf.in/image/cache/catalog/mens-t-shirts/breaking-bad-official-heisenberg-t-shirt-india-438x438.jpg',
                    height: MediaQuery.of(context).size.width / 2,
                    fit: BoxFit.fitHeight, 
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                  child: new Text(
                    'Mr.Crit in full face',
                    style:
                        TextStyle(fontSize: 16.0, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.grey,
                        ),
                    maxLines: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
                  child: new Text(
                    'IDR 125K',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            )));
  }
}

class ItemDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                _showImage(context),
                _showPrice(),
                _showTitleDesc(),
                Divider(),
                _showMaterial(),
                _showSize(),
                Divider(),
              ],
            ),
          ),
          _showButton(context)
        ],
      ),
    );
  }
  Widget _showImage(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.5,
      padding: EdgeInsets.all(8.0),
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          NetworkImage(
              'https://static.thefancydeal.com/uploads/edd/2017/08/buy-tshirt-design.jpg'),
          NetworkImage(
              'https://image.dhgate.com/0x0/f2/albu/g6/M00/74/9F/rBVaR1oySymAMz2TAAM9Nf6_oQA427.jpg'),
          NetworkImage(
              'https://static.thefancydeal.com/uploads/edd/2018/01/Fearless-buy-t-shirt-design.jpg'),
        ],
        // animationCurve: Curves.fastOutSlowIn,
        // animationDuration: Duration(milliseconds: 0),
        autoplay: false,
        dotSize: 6.0,
        indicatorBgPadding: 6.0,
        dotBgColor: Colors.transparent,
        dotColor: Colors.grey,
        
      ),
    );
  }

  Widget _showPrice() {
    return Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: new Container(child: Text('Mr.Crit in full face', style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey,
                        ),
                        maxLines: 2,),),
                ),
                Text('IDR 135K', style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.lime
                ),
                maxLines: 2,)
              ],
            ),
          );
  }

  Widget _showTitleDesc() {
    return Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Column(
              children: <Widget>[
                Text('Our new design : Mr.Crit in full face is inspired by the some one we call HERO in our new community. A nice old man who strugle from day to night that inspired us that life is not about complaint.',
                style: TextStyle(
                  letterSpacing: 0.5
                  ),)
              ],
            ),
          );
  }

  Widget _showMaterial() {
    return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              // color: Colors.white70,
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 16.0),
              child: Text(
                'Material', style: TextStyle(
                  color: Colors.grey
                ),
              ),
            ),
          ),
          Container(
            // color: Colors.white70,
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
            child: Text(
                'Cotton Combbed 30s', style: TextStyle(
                  color: Colors.lime
                ),
              ),
          ),
        ],
      );
  }

  Widget _showSize() {
    return Row(
        children: <Widget>[
          Expanded(
              child: Container(
              // color: Colors.white70,
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Text(
                'Available Size', style: TextStyle(
                  color: Colors.grey
                ),
              ),
            ),
          ),
          Container(
            // color: Colors.white70,
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 16.0),
            child: Text(
                'M / L / XL', style: TextStyle(
                  color: Colors.lime
                ),
              ),
          ),
        ],
      );
  }

  Widget _showButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: RaisedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOut()));
        },
        color: Colors.lime,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: Text('Buy Now', style: TextStyle(
          color: Colors.white
        ),),
      ),
    );
  }

}

class CheckOut extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CheckOut'),
      ),
      body: ListView(
        children: <Widget>[
          _showBuyerInfoText(),
          Divider(),
          _showName(),
          _showMobile(),
          _showAddress(),
          _showItemInfoText(),
          Divider(),
        ],
      ),
    );
  }

  Widget _showBuyerInfoText() {
    return Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text('Info Pembeli', style: TextStyle(
            fontSize: 18.0
          ),),
        );
  }

  Widget _showName() {
    return Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: TextFormField(
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder())
            ),
          );
  }

  Widget _showMobile() {
    return Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: TextFormField(
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'Nomor HP',
                border: OutlineInputBorder()),
            ),
          );
  }

  Widget _showAddress() {
    return Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
            child: TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Alamat Pengiriman',
                border: OutlineInputBorder()),
            ),
          );
  }

  Widget _showItemInfoText() {
    return Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text('Info Barang', style: TextStyle(
            fontSize: 18.0
          ),),
        );
  }

}