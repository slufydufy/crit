import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class BrandEdit extends StatefulWidget {
  final Future item;
  BrandEdit({this.item});
  @override
  BrandEditState createState() => BrandEditState();
}

class BrandEditState extends State<BrandEdit> {

  final titleTxtCont = TextEditingController();
  final descTxtCont = TextEditingController();
  final imgUrlTxtCont = TextEditingController();
  final emailTxtCont = TextEditingController();
  final mobileTxtCont = TextEditingController();
  // CrudMethod crudObj = CrudMethod();
  final _formkey = GlobalKey<FormState>();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Brand'),
        actions: <Widget>[
          SizedBox(
            width: 60.0,
            child: FlatButton(child: Icon(Icons.check_circle, size: 32,),
              onPressed: (){}
              ),
          )
        ],
      ),
      body: FutureBuilder(
        future: widget.item,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            titleTxtCont.text = snapshot.data[0].data['title'];
            descTxtCont.text = snapshot.data[0].data['desc'];
            imgUrlTxtCont.text = snapshot.data[0].data['imgUrl'];
            emailTxtCont.text = snapshot.data[0].data['email'];
            mobileTxtCont.text = snapshot.data[0].data['mobile'];
            return ListView(
              children: <Widget>[
                _brandForm(),
            
              ],
            );
          }
        },
      )
      
    );
  }

  Widget _brandForm() {
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[_showImgUrl(), _showTitle(), _showDesc(), _showEmail(), _showMobile()],
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