import 'package:bnl_task/services/models/komponen/KomponenModel.dart';
import 'package:bnl_task/utils/loadingview.dart';
import 'package:bnl_task/utils/warna.dart';
import 'package:bnl_task/views/pages/komponen/networkkomponen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'komponentile.dart';

class KomponenPageSearch extends StatefulWidget {
  @override
  _KomponenPageSearchState createState() => _KomponenPageSearchState();
}

class _KomponenPageSearchState extends State<KomponenPageSearch> {
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "";
  List<KomponenModel> _komponents = <KomponenModel>[];
  List<KomponenModel> _komponentsDisplay = <KomponenModel>[];

  bool _isLoading = true;

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Komponen'),
        centerTitle: true,
        backgroundColor: thirdcolor,
      ),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (!_isLoading) {
                return index == 0
                    ? _searchBar()
                    : KomponenTile(
                        komponen: this._komponentsDisplay[index - 1],
                        token: token!,
                      );
                // : SiteTile(site: this._sitesDisplay[index - 1]);
              } else {
                return LoadingView();
              }
            },
            itemCount: _komponentsDisplay.length + 1,
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
