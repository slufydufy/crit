import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemEdit extends StatefulWidget {
  final String itemId;
  final String title;
  final String desc;
  final String mainImg;
  final String price;
  final String material;
  final String addInfo;
  final String moreImg1;
  final String moreImg2;
  final String moreImg3;
  final String category;


  ItemEdit({this.itemId, this.title, this.desc, this.mainImg, this.price, this.material, this.addInfo, this.moreImg1, this.moreImg2, this.moreImg3, this.category});

  @override
  ItemEditState createState() => ItemEditState();
}

class ItemEditState extends State<ItemEdit> {
  BuildContext scafoldContext;

  Future _catData;

  Future fetchCategory() async {
    QuerySnapshot catData =
        await Firestore.instance.collection('itemCategory').getDocuments();
    return catData.documents;
  }

  final _formkey = GlobalKey<FormState>();
  final itemNameTxtCont = TextEditingController();
  final itemDescTxtCont = TextEditingController();
  final mainImageTxtCont = TextEditingController();
  final priceTxtCont = TextEditingController();
  final materialTxtCont = TextEditingController();
  final addInfoTxtCont = TextEditingController();
  final otherImage1TxtCont = TextEditingController();
  final otherImage2TxtCont = TextEditingController();
  final otherImage3TxtCont = TextEditingController();
  String _itemCategory;

  @override
  void dispose() {
    itemNameTxtCont.dispose();
    itemDescTxtCont.dispose();
    mainImageTxtCont.dispose();
    priceTxtCont.dispose();
    materialTxtCont.dispose();
    addInfoTxtCont.dispose();
    otherImage1TxtCont.dispose();
    otherImage2TxtCont.dispose();
    otherImage3TxtCont.dispose();
    super.dispose();
  }

  updateItemdDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: Text('Submit new data ?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: updateData
            )
          ],
        );
      },
    );
  }

  void createSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.black,
    );
    Scaffold.of(scafoldContext).showSnackBar(snackBar);
  }

  updateData() {
    if (_itemCategory == null) {
      Navigator.pop(context);
      createSnackBar('Pilih Kategori');
    } else if(_formkey.currentState.validate()) {
      Firestore.instance.collection('items').document(widget.itemId).updateData({
        'itemName': itemNameTxtCont.text,
        'itemDesc': itemDescTxtCont.text,
        'mainImg': mainImageTxtCont.text,
        'price': priceTxtCont.text,
        'material': materialTxtCont.text,
        'addInfo': addInfoTxtCont.text,
        'moreImg1': otherImage1TxtCont.text,
        'moreImg2': otherImage2TxtCont.text,
        'moreImg3': otherImage3TxtCont.text,
        'category': _itemCategory,
      }).then((result) {
        dismissEditItemDialog(context);
      }).catchError((e) {
        print(e);
      });
    } else {
      Navigator.pop(context);
    }
  }

  dismissEditItemDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: Text(
              'Data item berhasil diubah, anda dapat melihat data baru pada halaman : Profile > Brand Page'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _catData = fetchCategory();
    itemNameTxtCont.text = widget.title;
    itemDescTxtCont.text = widget.desc;
    mainImageTxtCont.text = widget.mainImg;
    priceTxtCont.text = widget.price;
    materialTxtCont.text = widget.material;
    addInfoTxtCont.text = widget.addInfo ?? "";
    otherImage1TxtCont.text = widget.moreImg1 ?? "";
    otherImage2TxtCont.text = widget.moreImg2 ?? "";
    otherImage3TxtCont.text = widget.moreImg3 ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      appBar: AppBar(
        title: Text('Item Edit'),
        actions: <Widget>[
          SizedBox(
            width: 60.0,
            child: FlatButton(child: Icon(Icons.check_circle, size: 32,),
              onPressed: updateItemdDialog
              ),
          )
        ],
      ),
      body: Builder(
          builder: (BuildContext context) {
            scafoldContext = context;
            return
            ListView(
              children: <Widget>[
                _brandForm(),
                _showCategory(),
              ],
            );
            }
          )
    );
  }

  Widget _brandForm() {
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[_showName(), _showDesc(), _showMainImage(), _showPrice(), _showMaterial(), _showAddInfo(), _showOtherImage1(), _showOtherImage2(), _showOtherImage3()],
      ),
    );
  }

  Widget _showName() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
          controller: itemNameTxtCont,
          maxLines: 1,
          validator: (value) {
            if (value.isEmpty) {
              return 'Nama item belum diisi';
            }
          },
          decoration: InputDecoration(
              labelText: 'Nama Item',
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder())),
    );
  }

  Widget _showDesc() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
          controller: itemDescTxtCont,
          maxLines: 1,
          validator: (value) {
            if (value.isEmpty) {
              return 'Deskripsi item belum diisi';
            }
          },
          decoration: InputDecoration(
              labelText: 'Deskripsi Item',
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder())),
    );
  }

  Widget _showMainImage() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
          controller: mainImageTxtCont,
          maxLines: 1,
          validator: (value) {
            if (value.isEmpty) {
              return 'URL gambar utama belum diisi';
            }
          },
          decoration: InputDecoration(
              labelText: 'URL Gambar utama',
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder())),
    );
  }

  Widget _showPrice() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
          controller: priceTxtCont,
          maxLines: 1,
          keyboardType: TextInputType.number,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value.isEmpty) {
              return 'Harga belum diisi';
            }
          },
          decoration: InputDecoration(
              labelText: 'Harga satuan (IDR)',
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder())),
    );
  }

  Widget _showMaterial() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
          controller: materialTxtCont,
          maxLines: 1,
          validator: (value) {
            if (value.isEmpty) {
              return 'Material / Bahan belum diisi';
            }
          },
          decoration: InputDecoration(
              labelText: 'Material / Bahan',
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder())),
    );
  }

  Widget _showAddInfo() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
        controller: addInfoTxtCont,
        maxLines: 2,
        maxLength: 120,
        decoration: InputDecoration(
            labelText: 'Info Tambahan',
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border: OutlineInputBorder()),
      ),
    );
  }

  Widget _showOtherImage1() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
          controller: otherImage1TxtCont,
          maxLines: 1,
          decoration: InputDecoration(
              labelText: 'URL Gambar lain 1',
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder())),
    );
  }

  Widget _showOtherImage2() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
          controller: otherImage2TxtCont,
          maxLines: 1,
          decoration: InputDecoration(
              labelText: 'URL Gambar lain 2',
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder())),
    );
  }

  Widget _showOtherImage3() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
          controller: otherImage3TxtCont,
          maxLines: 1,
          decoration: InputDecoration(
              labelText: 'URL Gambar lain 3',
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder())),
    );
  }

  Widget _showCategory() {
    return FutureBuilder(
      future: _catData,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Loading'),);
        } else {
          List catList = [];
          for (var i = 0; i < snapshot.data.length; i++) {
          catList.add(snapshot.data[i].data['name']);
          }
          return
          Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 0.0),
                child: Text(
                  'Kategori',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 0.0),
                child: DropdownButton(
                  hint: Text(' Pilih ', style: TextStyle(color: Colors.grey)),
                  items: catList.map((size) {
                    return DropdownMenuItem(
                      child: Text(
                        size,
                        style: TextStyle(color: Colors.grey),
                      ),
                      value: size,
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      _itemCategory = newVal;
                    });
                  },
                  value: _itemCategory,
                )),
          ],
        );
        }
      },
    );
  }
}