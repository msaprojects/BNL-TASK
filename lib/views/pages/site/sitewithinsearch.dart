
import 'package:bnl_task/services/models/site/siteModel.dart';
import 'package:bnl_task/utils/loadingview.dart';
import 'package:bnl_task/utils/warna.dart';
import 'package:bnl_task/views/pages/site/networksite.dart';
import 'package:bnl_task/views/pages/site/sitetile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottommodalsite.dart';

class SiteSearchPage extends StatefulWidget {
  @override
  _SiteSearchPageState createState() => _SiteSearchPageState();
}

class _SiteSearchPageState extends State<SiteSearchPage> {
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "";
  List<SiteModel> _sites = <SiteModel>[];
  List<SiteModel> _sitesDisplay = <SiteModel>[];

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
      username = sp.getString("username");
      jabatan = sp.getString("jabatan");
    });
    fetchSite(token!).then((value) {
      print("IN? " + token!);
      setState(() {
        _isLoading = false;
        _sites.addAll(value);
        _sitesDisplay = _sites;
        print(_sitesDisplay.length);
      });
    });
  }

  @override
  initState() {
    cekToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Daftar Site'),
          centerTitle: true,
          backgroundColor: thirdcolor,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              ),
            )
          ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          BottomSite().modalAddSite(context, 'tambah', token!, '', '', '');
          // _modalAddSite(context, 'tambah');
        },
        label: Text(
          'Tambah Site',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: secondcolor,
        icon: Icon(
          Icons.cabin_outlined,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (!_isLoading) {
                return index == 0
                    ? _searchBar()
                    : SiteTile(
                        site: this._sitesDisplay[index - 1],
                        token: token!,
                      );
                // : SiteTile(site: this._sitesDisplay[index - 1]);
              } else {
                return LoadingView();
              }
            },
            itemCount: _sitesDisplay.length + 1,
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
            _sitesDisplay = _sites.where((u) {
              var fNama = u.nama.toLowerCase();
              var fKeterangan = u.keterangan.toLowerCase();
              return fNama.contains(searchText) ||
                  fKeterangan.contains(searchText);
            }).toList();
          });
        },
        // controller: _textController,
        decoration: InputDecoration(
          fillColor: thirdcolor,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          hintText: 'Search Site',
        ),
      ),
    );
  }
}
