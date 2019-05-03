import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'brandCreate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'itemAdd.dart';
import 'brandEdit.dart';
import 'itemDetail.dart';
import 'itemEdit.dart';
import 'sales.dart';

class BrandPage extends StatefulWidget {

  @override
  BrandPageState createState() => BrandPageState();
}

class BrandPageState extends State<BrandPage> {
  Future _brandData;
  Future _itemData;
  String _documentId;
  String title;
  String desc;
  String imgUrl;
  String email;
  String mobile;
  String brandId;
  String bank;
  String bankAcc;
  String noRek;


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
        title: Text('Brand Page')
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
                    child: Text('You dont own any brand, Create your brand now!', textAlign: TextAlign.center,),
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
            final _docId = snapshot.data[0].documentID;
            _documentId = _docId;
            title = snapshot.data[0].data['title'];
            desc = snapshot.data[0].data['desc'];
            imgUrl = snapshot.data[0].data['imgUrl'];
            email = snapshot.data[0].data['email'];
            mobile = snapshot.data[0].data['mobile'];
            brandId = snapshot.data[0].data['brandId'];
            bank = snapshot.data[0].data['bank'];
            bankAcc = snapshot.data[0].data['bankAcc'];
            noRek = snapshot.data[0].data['noRek'];
            return ListView(
              children: <Widget>[
                _showPenjualanText(),
                _showBrandInfo(),
                _showBrandTitle(snapshot.data[0].data['title']),
                _showBrandDesc(snapshot.data[0].data['desc']),
                _showBrandImg(snapshot.data[0].data['imgUrl']),
                _showBrandEmail(snapshot.data[0].data['email']),
                _showBrandPhone(snapshot.data[0].data['mobile']),
                Divider(),
                _bankName(snapshot.data[0].data['bank']),
                _bankAccName(snapshot.data[0].data['bankAcc']),
                _noRek(snapshot.data[0].data['noRek']),
                _showItemText(snapshot.data[0].data['title']),
                _gridView(snapshot.data[0].data['title'])
              ],
            );
          }
        },
      )
    );
  }

  Widget _showEditBrand() {
    return
    FutureBuilder(
      future: _brandData,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data.length < 1) {
          return
          IconButton(
            icon: Icon(Icons.add_circle),
            iconSize: 30,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BrandCreate()));
            },
          );
        } else {
          return
          SizedBox(
          width: 60.0,
          child: FlatButton(child: Icon(Icons.edit),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => BrandEdit(docId: _documentId, title: title, desc: desc, imgUrl: imgUrl, email: email, mobile: mobile, brandId: brandId, bank: bank, bankAcc: bankAcc, noRek: noRek,)));
            }));
        }
      },
        
    );
  }

  Widget _showPenjualanText() {
    return 
    Container(
      color: Colors.white,
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: 
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SalesMain()));
          },
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Colors.lime, width: 1.0)
            ),
            child: Text('Cek Penjualan', style: TextStyle(
                  fontSize: 16.0,
                ),),
          ),
        ),
      ),
    );
  }

  Widget _showBrandInfo() {
    return Container(
      color: Colors.grey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
                child: Text(
                'Brand Info',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          _showEditBrand()
        ],
      ),
    );
  }

  Widget _showBrandTitle(item) {
    return
    ListTile(
      title: Text(item ?? ""),
      subtitle: Text('Brand Name'),
    );
  }

  Widget _showBrandDesc(item) {
    return
    ListTile(
      title: Text(item ?? "", maxLines: 2,),
      subtitle: Text('Brand Description'),
    );
  }

  Widget _showBrandImg(item) {
    return
    ListTile(
      title: Text('Image Theme'),
      subtitle: Text('Brand Image Theme'),
      trailing: Image.network(item ?? "",
        height: 50,
        width: 50,
        fit: BoxFit.cover,),
    );
  }

  Widget _showBrandEmail(item) {
    return
    ListTile(
      title: Text(item ?? ""),
      subtitle: Text('Brand Email'),
    );
  }

  Widget _showBrandPhone(item) {
    return
    ListTile(
      title: Text(item ?? ""),
      subtitle: Text('Phone'),
    );
  }

  Widget _bankName(item) {
    return
    ListTile(
      title: Text(item  ?? ""),
      subtitle: Text('Nama Bank'),
    );
  }

  Widget _bankAccName(item) {
    return
    ListTile(
      title: Text(item ?? ""),
      subtitle: Text('Nama Pemilik Account'),
    );
  }

  Widget _noRek(item) {
    return
    ListTile(
      title: Text(item ?? ""),
      subtitle: Text('Nomor Rekening'),
    );
  }

  Widget _showItemText(brandName) {
    return Container(
      color: Colors.grey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
                child: Text(
                'My Items',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.0),
              child: IconButton(
              icon: Icon(Icons.add_circle),
              iconSize: 30,
              color: Colors.black,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ItemAdd(brandName: brandName)));
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _gridView(brandName) {
    return Container(
        padding: EdgeInsets.fromLTRB(4.0, 16.0, 4.0, 16.0),
        child: FutureBuilder(
            future: _itemData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data.length == 0) {
                return 
                FlatButton(
                  onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ItemAdd(brandName: brandName)));
                  },
                  child: Center(
                    child: 
                      Text('Add an item now', style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey
                      ),)),
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
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => ItemDetail(item: snapshot)));
        },
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
              ),
              Center(
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.5),
                    border: new Border.all(
                      width: 0.0,
                      color: Colors.white,
                    ),
                  ),
                  child: IconButton(
                    onPressed: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ItemEdit(
                          itemId: snapshot.documentID,
                          title: snapshot.data['itemName'],
                          desc: snapshot.data['itemDesc'],
                          mainImg: snapshot.data['mainImg'],
                          price: snapshot.data['price'],
                          material: snapshot.data['material'],
                          addInfo: snapshot.data['addInfo'],
                          moreImg1: snapshot.data['moreImg1'],
                          moreImg2: snapshot.data['moreImg2'],
                          moreImg3: snapshot.data['moreImg3'],
                          )));
                    },
                    color: Colors.white,
                    icon: Icon(Icons.edit),
                    iconSize: 24.0,
          ),
                ),
                
              )
            ],
          ),
        ));
  }
}