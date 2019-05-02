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
  final String brandId;
  final String bank;
  final String bankAcc;
  final String noRek;

  BrandEdit({this.docId, this.title, this.desc, this.imgUrl, this.email, this.mobile, this.brandId, this.bank, this.bankAcc, this.noRek});
  @override
  BrandEditState createState() => BrandEditState();
}

class BrandEditState extends State<BrandEdit> {
  BuildContext scafoldContext;

  final titleTxtCont = TextEditingController();
  final descTxtCont = TextEditingController();
  final imgUrlTxtCont = TextEditingController();
  final emailTxtCont = TextEditingController();
  final mobileTxtCont = TextEditingController();
  final delTxtCont = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final bankNameTxtCont = TextEditingController();
  final accNamextCont = TextEditingController();
  final rekNumberTxtCont = TextEditingController();
  final _bankkey = GlobalKey<FormState>();

  String delText;

  updateBrandDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Brand'),
          content: Text('Masukkan data baru ?'),
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
                updateBrandData();
              }
            )
          ],
        );
      },
    );
  }

  deleteBrandDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Brand'),
          content: Text('Apakah anda ingin menghapus Brand ?'),
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
                confirmDeleteDialog();
              }
            )
          ],
        );
      },
    );
  }

  confirmDeleteDialog() async {
    String brandName = widget.title;
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Masukkan text dibawah sebagai konfirmasi: ' + '\n\"$brandName\"'),
          content: TextField(
            controller: delTxtCont,
          ),
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
                delText = delTxtCont.text;
                checkBrandItem();
              }
            )
          ],
        );
      },
    );
  }

  checkBrandItem() {
    if (delTxtCont.text == widget.title ) {
      Firestore.instance.collection('items').where('brandId', isEqualTo: widget.brandId).getDocuments().then((result) {
      print(result.documents.length);
      if (result.documents.length == 0 ) {
        Firestore.instance.collection('brands').document(widget.docId).delete();
        Navigator.pop(context);
        dismissDeleteSuccDialog();
      } else {
        Navigator.pop(context);
        deleteItemExist();
      }
    });
    } else {
      Navigator.pop(context);
      createSnackBar('Text yang dimasukkan Salah');
    }
  }

  dismissDeleteSuccDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Berhasil Dihapus'),
          content: Text(
              'Brand berhasil dihapus, anda dapat membuat brand pada halaman : Profile > Brand Page'),
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

  deleteItemExist() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Item belum kosong'),
          content: Text('Hapus semua item sebelum menghapus brand'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              }
            )
          ],
        );
      },
    );
  }

  updateBrandData() {
    if(_formkey.currentState.validate()) {
      Firestore.instance.collection('brands').document(widget.docId).updateData({
        'imgUrl': imgUrlTxtCont.text,
        'title': titleTxtCont.text,
        'desc': descTxtCont.text,
        'email': emailTxtCont.text,
        'mobile': mobileTxtCont.text,
        'bank': bankNameTxtCont.text,
        'bankAcc': accNamextCont.text,
        'noRek': rekNumberTxtCont.text
      }).then((result) {
        dismissEditBrandDialog(context);
      }).catchError((e) {
        print(e);
      });
    } else {
      Navigator.pop(context);
    }
  }

  void createSnackBar(String message) {
    final snackBar = SnackBar(content: 
     Text(message, style: TextStyle(fontWeight: FontWeight.bold),),
    backgroundColor: Colors.grey.withOpacity(0.8),
    );
    Scaffold.of(scafoldContext).showSnackBar(snackBar);
  }

  dismissEditBrandDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Brand'),
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
    delTxtCont.dispose();
    bankNameTxtCont.dispose();
    accNamextCont.dispose();
    rekNumberTxtCont.dispose();
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
    bankNameTxtCont.text = widget.bank;
    accNamextCont.text = widget.bankAcc;
    rekNumberTxtCont.text = widget.noRek;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Brand'),
        actions: <Widget>[
          SizedBox(
            width: 60.0,
            child: FlatButton(child: Icon(Icons.delete_forever, size: 30,),
              onPressed: deleteBrandDialog
              ),
          )
        ],
      ),
      body: 
      Builder(builder: (BuildContext context) {
      scafoldContext = context;
      return
      Column(
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
      );
      })
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
      onTap: updateBrandDialog,
    );
  }
}