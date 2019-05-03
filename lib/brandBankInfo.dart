import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BrandBankInfo extends StatefulWidget {
  final String brandId;
  BrandBankInfo({this.brandId});

  @override
  BrandBankInfoState createState() => BrandBankInfoState();
}

class BrandBankInfoState extends State<BrandBankInfo> {

  Future _brandData;

  Future fetchBrand() async {
    QuerySnapshot brandData =
        await Firestore.instance.collection('brands').where('brandId', isEqualTo: widget.brandId).getDocuments();
    return brandData.documents;
  }

  @override
  void initState() {
    super.initState();
    _brandData = fetchBrand();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brand Bank Info'),
      ),
      body: FutureBuilder(
              future: _brandData,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return
                  ListView(
                    children: <Widget>[
                      Container(
                        color: Colors.grey[300],
                        child: ListTile(
                          title: Text(snapshot.data[0]['title']),
                          subtitle: Text('Brand Name'),
                        ),
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: ListTile(
                          title: Text(snapshot.data[0]['email']),
                          subtitle: Text('Brand Name'),
                        ),
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: ListTile(
                          title: Text(snapshot.data[0]['mobile']),
                          subtitle: Text('Brand Name'),
                        ),
                      ),
                      ListTile(
                        title: Text('Nama Bank'),
                        trailing: Text(snapshot.data[0]['bank'] ?? ""),
                      ),
                      ListTile(
                        title: Text('Pemilik Account'),
                        trailing: Text(snapshot.data[0]['bankAcc'] ?? ""),
                      ),
                      ListTile(
                        title: Text('Nomor Rekening'),
                        trailing: Text(snapshot.data[0]['noRek'] ?? ""),
                      ),
                    ],
                  );
                }

              },
        ),
    );
  }
}