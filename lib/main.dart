import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        title: Text('Crit\''),
      ),
      body: ListView(
        children: <Widget>[
          _showCarousel(context),
          _gridView(context)
        ],
      ),
    );
  }

  Widget _showCarousel(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
            height: height * 0.25,
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

  Widget _gridView(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.0, 0.0, 8.0, 4.0),
      child: GridView.count(
        childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.7),
        physics: ScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        children: List.generate(8, (index) {
          return _itemCard(context);
        })
      ),
    );
  }

  Widget _itemCard(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      
      child: new Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmuKYRLIe_TOCWpcCIlrtZy9DBG_-gXYQrwaEJokBTOIwGZcNffA',
                  height: height * 0.18,
                  // width: 150,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                  child: new Text('Item Available U powers', style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                  child: new Text('Item Available', style: TextStyle(
                    // fontSize: 18.0,
                    // fontWeight: FontWeight.bold
                  ),),
                )
              ],
            ),
          ),
          
    );
  }
}

