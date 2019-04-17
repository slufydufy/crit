import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class BrandEdit extends StatefulWidget {
  final String docId;
  final String title;
  final String desc;
  final String imgUrl;
  final String email;
  final String mobile;
  BrandEdit({this.docId, this.title, this.desc, this.imgUrl, this.email, this.mobile});
  @override
  BrandEditState createState() => BrandEditState();
}

class BrandEditState extends State<BrandEdit> {

  final titleTxtCont = TextEditingController();
  final descTxtCont = TextEditingController();
  final imgUrlTxtCont = TextEditingController();
  final emailTxtCont = TextEditingController();
  final mobileTxtCont = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  updateBrandDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Brand'),
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

  updateData() {
    if(_formkey.currentState.validate()) {
      Firestore.instance.collection('brands').document(widget.docId).updateData({
        'imgUrl': imgUrlTxtCont.text,
        'title': titleTxtCont.text,
        'desc': descTxtCont.text,
        'email': emailTxtCont.text,
        'mobile': mobileTxtCont.text
      }).then((result) {
        dismissEditBrandDialog(context);
      }).catchError((e) {
        print(e);
      });
    } else {
      Navigator.pop(context);
    }
  }

  dismissEditBrandDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Brand'),
          content: Text(
              'Data brand berhasil diubah, anda dapat melihat data baru pada halaman : Profile > Brand Page'),
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
  void dispose() {
    titleTxtCont.dispose();
    descTxtCont.dispose();
    imgUrlTxtCont.dispose();
    emailTxtCont.dispose();
    mobileTxtCont.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    titleTxtCont.text = widget.title;
    descTxtCont.text = widget.desc;
    imgUrlTxtCont.text = widget.imgUrl;
    emailTxtCont.text = widget.email;
    mobileTxtCont.text = widget.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Brand'),
        actions: <Widget>[
          SizedBox(
            width: 60.0,
            child: FlatButton(child: Icon(Icons.check_circle, size: 32,),
              onPressed: updateBrandDialog
              ),
          )
        ],
      ),
      body: ListView(
              children: <Widget>[
                _brandForm(),
              ],
            )
    );
  }

  Widget _brandForm() {
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[_showTitle(), _showDesc(), _showImgUrl(), _showEmail(), _showMobile()],
      ),
    );
  }

  Widget _showTitle() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
          controller: titleTxtCont,
          maxLines: 1,
          validator: (value) {
            if (value.isEmpty) {
              return 'Nama brand belum diisi';
            }
          },
          decoration: InputDecoration(
              labelText: 'Nama Brand',
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder())),
    );
  }

  Widget _showDesc() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
        controller: descTxtCont,
        maxLines: 3,
        validator: (value) {
          if (value.isEmpty) {
            return 'Deskripsi belum diisi';
          }
        },
        decoration: InputDecoration(
            labelText: 'Deskripsi',
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border: OutlineInputBorder()),
      ),
    );
  }

  Widget _showImgUrl() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
          controller: imgUrlTxtCont,
          maxLines: 1,
          validator: (value) {
            if (value.isEmpty) {
              return 'URL Gambar belum diisi';
            }
          },
          decoration: InputDecoration(
              labelText: 'URL Gambar Brand',
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder())),
    );
  }

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
          controller: emailTxtCont,
          keyboardType: TextInputType.emailAddress,
          maxLines: 1,
          validator: (value) {
            if (value.isEmpty) {
              return 'Email belum diisi';
            }
          },
          decoration: InputDecoration(
              labelText: 'Contact Email',
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder())),
    );
  }

  Widget _showMobile() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
        controller: mobileTxtCont,
        keyboardType: TextInputType.phone,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        maxLines: 1,
        validator: (value) {
          if (value.isEmpty) {
            return 'Nomor HP belum diisi';
          }
        },
        decoration: InputDecoration(
            labelText: 'Nomor HP',
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border: OutlineInputBorder()),
      ),
    );
  }
}