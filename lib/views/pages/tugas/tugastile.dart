import 'dart:convert';

import 'package:bnl_task/services/models/komponen/KomponenModel.dart';
import 'package:bnl_task/views/pages/tugas/tugasbottom.dart';
import 'package:flutter/material.dart';

class TugasTile extends StatefulWidget {
  var tanggal, keterangan, kategori;
  TugasTile(
      {required this.tanggal,
      required this.keterangan,
      required this.kategori});
  // final String token;

  @override
  State<TugasTile> createState() => _TugasTileState();
}

class _TugasTileState extends State<TugasTile> {
  late KomponenModel komponen;
  var tanggal1, keterangan1, kategori1;
  // List _itemsTugas = [];

  // Future<void> tugasTerbaru() async {
  //   final String response =
  //       await rootBundle.loadString('assets/json/tugas.json');
  //   final data = await json.decode(response);
  //   setState(() {
  //     _itemsTugas = data["items"];
  //   });
  // }

  @override
  initState() {
    // print("heyyo"+_itemsTugas.toString());
    // tugasTerbaru();
    tanggal1 = widget.tanggal;
    keterangan1 = widget.keterangan;
    kategori1 = widget.kategori;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
            elevation: 0.0,
            child: InkWell(
              onTap: () {
                BottomTugas().modalActionItem(
                  context, 
                  tanggal1,
                  keterangan1,
                  kategori1,
                  );
                // BottomTugas().modalActionItem(
                //     context,
                //     widget.token,
                //     komponen.nama,
                //     komponen.nomesin.toString(),
                //     komponen.mesin,
                //     komponen.site,
                //     komponen.jumlah.toString(),
                //     komponen.idkomponen.toString(),
                //     komponen.idmesin.toString());
              },
              child: Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('tanggal : ', style: TextStyle(fontSize: 18.0)),
                        Text(tanggal1.toString(),
                            style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text('kategori : ', style: TextStyle(fontSize: 18.0)),
                        Text(kategori1.toString(),
                            style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('keterangan : ' + keterangan1.toString(),
                        style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              ),
            )));
  }
}
