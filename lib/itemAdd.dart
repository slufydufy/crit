import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'crud.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemAdd extends StatefulWidget {
  final String brandName;
  ItemAdd({this.brandName});

  @override
  ItemAddState createState() => ItemAddState();
}

class ItemAddState extends State<ItemAdd> {
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
  String _uid;
  CrudMethod crudObj = CrudMethod();

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

  checkItemDialog() async {
    FirebaseUser status = await FirebaseAuth.instance.currentUser();
    _uid = status.uid;
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Item'),
          content: Text(
              'Apakah semua data yang dimasukkan telah benar ?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                submitItem();
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  submitItem(){
    var today = DateTime.now();
    String formatter =
        "${today.year.toString()}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}";
    if (_itemCategory == null) {
      Navigator.pop(context);
      createSnackBar('Pilih Kategori');
    } else if (_formkey.currentState.validate()) {
      crudObj.addItem({
        'brandId': 'br_' + _uid,
        'brandName': widget.brandName,
        'cDate' : formatter,
        'mainImg': mainImageTxtCont.text,
        'itemName': itemNameTxtCont.text,
        'itemDesc': itemDescTxtCont.text,
        'price': priceTxtCont.text,
        'material': materialTxtCont.text,
        'addInfo': addInfoTxtCont.text,
        'moreImg1': otherImage1TxtCont.text,
        'moreImg2': otherImage2TxtCont.text,
        'moreImg3': otherImage3TxtCont.text,
        'category': _itemCategory,
      }).then((result) {
        dismissItemDialog(context);
      }).catchError((e) {
        print(e);
      });
    } else {
        Navigator.pop(context);
    }
  }

  dismissItemDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Item'),
          content: Text(
              'Item berhasil dibuat, anda dapat mengubah data pada halaman : Profile > Brand Page'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Builder(
          builder: (BuildContext context) {
            scafoldContext = context;
            return Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                _brandForm(),
                _showCategory()
              ],
            ),
          ),
          _showSubmitButton(context)
        ],
      );
      })
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
            labelText: 'Info Tambahan (Size, Color, etc)',
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

  Widget _showSubmitButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.grey,
        child: Center(
          child: Text(
            'Submit',
            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      onTap: checkItemDialog,
    );
  }
}