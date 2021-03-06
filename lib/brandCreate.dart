import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'crud.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BrandCreate extends StatefulWidget {

  @override
  BrandCreateState createState() => BrandCreateState();
}

class BrandCreateState extends State<BrandCreate> {

  final titleTxtCont = TextEditingController();
  final descTxtCont = TextEditingController();
  final imgUrlTxtCont = TextEditingController();
  final emailTxtCont = TextEditingController();
  final mobileTxtCont = TextEditingController();
  final bankNameTxtCont = TextEditingController();
  final accNamextCont = TextEditingController();
  final rekNumberTxtCont = TextEditingController();
  CrudMethod crudObj = CrudMethod();
  final _formkey = GlobalKey<FormState>();
  final _bankkey = GlobalKey<FormState>();
  String _uid;

  checkBrandDialog() async {
    FirebaseUser status = await FirebaseAuth.instance.currentUser();
    _uid = status.uid;
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Brand'),
          content: Text(
              'Apakah semua data yang dimasukkan telah benar ?'),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                submitBrand();
              },
            )
          ],
        );
      },
    );
  }

  submitBrand(){
    var today = DateTime.now();
    String formatter =
        "${today.year.toString()}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}";
    if (_formkey.currentState.validate() && _bankkey.currentState.validate()) {
      crudObj.addBrand({
        'brandId': 'br_' + _uid,
        'cDate' : formatter,
        'imgUrl': imgUrlTxtCont.text,
        'title': titleTxtCont.text,
        'desc': descTxtCont.text,
        'email': emailTxtCont.text,
        'mobile': mobileTxtCont.text,
        'bank': bankNameTxtCont.text,
        'bankAcc': accNamextCont.text,
        'noRek': rekNumberTxtCont.text,
      }).then((result) {
        dismissBrandDialog(context);
      }).catchError((e) {
        print(e);
      });
    } else {
        
    }
  }

  dismissBrandDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Brand'),
          content: Text(
              'Brand berhasil dibuat, anda dapat mengubah data pada halaman : Profile > Brand Page'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Brand'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                _showBrandText(),
                _brandForm(),
                _showAccText(),
                _bankForm()
              ],
            ),
          ),
          _showSubmitButton(context)
        ],
      ),
    );
  }

  Widget _showBrandText() {
    return
    Padding(
      padding: EdgeInsets.only(top: 16.0, left: 16.0),
      child: Text('Brand Profile', style: TextStyle(
        fontSize: 28,
        color: Colors.grey[800]
      ),),
    );
  }

  Widget _brandForm() {
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[ _showBrandTitle(), _showDesc(), _showImgUrl(), _showEmail(), _showMobile()],
      ),
    );
  }

  Widget _showBrandTitle() {
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

  Widget _showAccText() {
    return
    Padding(
      padding: EdgeInsets.only(top: 32.0, left: 16.0),
      child: Text('Bank Account', style: TextStyle(
        fontSize: 28,
        color: Colors.grey[800]
      ),),
    );
  }

  Widget _bankForm() {
    return Form(
      key: _bankkey,
      child: Column(
        children: <Widget>[ _showBankName(), _showBankAcc(), _showAccNumb()],
      ),
    );
  }

  Widget _showBankName() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
          controller: bankNameTxtCont,
          maxLines: 1,
          validator: (value) {
            if (value.isEmpty) {
              return 'Nama bank belum diisi';
            }
          },
          decoration: InputDecoration(
              labelText: 'Nama Bank',
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder())),
    );
  }

  Widget _showBankAcc() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
          controller: accNamextCont,
          maxLines: 1,
          validator: (value) {
            if (value.isEmpty) {
              return 'Nama pemilik account belum diisi';
            }
          },
          decoration: InputDecoration(
              labelText: 'Nama Pemilik Account',
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder())),
    );
  }

  Widget _showAccNumb() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
        controller: rekNumberTxtCont,
        keyboardType: TextInputType.phone,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        maxLines: 1,
        validator: (value) {
          if (value.isEmpty) {
            return 'Nomor Rek belum diisi';
          }
        },
        decoration: InputDecoration(
            labelText: 'Nomor Rekening',
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border: OutlineInputBorder()),
      ),
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
      onTap: checkBrandDialog,
    );
  }
}