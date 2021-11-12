import 'dart:convert';

import 'package:bnl_task/services/models/komponen/KomponenModel.dart';
import 'package:bnl_task/utils/loadingview.dart';
import 'package:bnl_task/utils/warna.dart';
import 'package:bnl_task/views/pages/komponen/networkkomponen.dart';
import 'package:bnl_task/views/pages/progress/progresstile.dart';
import 'package:bnl_task/views/pages/tugas/tugastile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressPageSearch extends StatefulWidget {
  var kategori;
  ProgressPageSearch({this.kategori});
  
  @override
  _ProgressPageSearchState createState() => _ProgressPageSearchState();
}

class _ProgressPageSearchState extends State<ProgressPageSearch> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _tecNama = TextEditingController(text: "");
  TextEditingController _tecJumlah = TextEditingController(text: "");
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "";
  List<KomponenModel> _komponents = <KomponenModel>[];
  List<KomponenModel> _komponentsDisplay = <KomponenModel>[];
  bool _isLoading = true;
  var tanggal, keterangan, kategori;

  List _itemsProgress = [];
  // * initial function for dummy tugas terbaru
  Future<void> tugasTerbaru() async {
    final String response =
        await rootBundle.loadString('assets/json/progress.json');
    final data = await json.decode(response);
    setState(() {
      _itemsProgress = data["items"];
    });
  }

  

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
      username = sp.getString("username");
      jabatan = sp.getString("jabatan");
    });
    fetchKomponen(token!, '0').then((value) {
      print("IN? " + token!);
      setState(() {
        _isLoading = false;
        _komponents.addAll(value);
        _komponentsDisplay = _komponents;
        print(_komponentsDisplay.length);
      });
    });
  }

  @override
  initState() {
    cekToken();
    print(token);
    tugasTerbaru();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Progress'),
        centerTitle: true,
        backgroundColor: thirdcolor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          right: -40.0,
                          top: -40.0,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: CircleAvatar(
                              child: Icon(Icons.close),
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormField(
                                  controller: _tecNama,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.date_range),
                                      labelText: 'Pilih Tanggal',
                                      hintText: '2020-02-20',
                                      suffixIcon: Icon(
                                          Icons.check_circle_outline_outlined))),
                              SizedBox(
                                height: 10.0,
                              ),
                             
                              TextFormField(
                                  controller: _tecJumlah,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.note_outlined),
                                      labelText: 'Keterangan',
                                      hintText: 'Masukkan Keterangan',
                                      suffixIcon: Icon(
                                          Icons.check_circle_outline_outlined))),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text("Submit"),
                                  onPressed: () {},
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        label: Text(
          'Tambah Progress',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: secondcolor,
        icon: Icon(
          Icons.add_box_outlined,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              print('indexss $index');
              if (_isLoading) {
                return index == 0
                    ? _searchBar()
                    : ProgressTile(
                        user: _itemsProgress[index]['user'],
                        keterangan: _itemsProgress[index]['keterangan'],
                        tanggal: _itemsProgress[index]['tanggal']);
              } else {
                return LoadingView();
              }
            },
            // if (!_isLoading) {
            // index == 0
            //     ? _searchBar()
            //     :
            // TugasTile(
            // kategori: this._itemsTugas[index -1],
            // kategori: this._itemsTugas,
            // komponen: this._komponentsDisplay[index - 1],
            //  keterangan: null, tanggal: null,
            // );
            // : SiteTile(site: this._sitesDisplay[index - 1]);
            // } else {
            //   return LoadingView();
            // }
            // itemCount: _komponentsDisplay.length + 1,
            itemCount: _itemsProgress.length,
          ),
        ),
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: TextField(
        autofocus: false,
        onChanged: (searchText) {
          searchText = searchText.toLowerCase();
          setState(() {
            _komponentsDisplay = _komponents.where((u) {
              var fNama = u.nama.toLowerCase();
              var fKeterangan = u.mesin.toLowerCase();
              var fnomesin = u.nomesin.toLowerCase();
              return fNama.contains(searchText) ||
                  fKeterangan.contains(searchText) ||
                  fnomesin.contains(searchText);
            }).toList();
          });
        },
        // controller: _textController,
        decoration: InputDecoration(
          fillColor: thirdcolor,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          hintText: 'Cari Komponen',
        ),
      ),
    );
  }
}
