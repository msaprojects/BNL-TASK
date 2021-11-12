import 'dart:convert';

import 'package:bnl_task/services/models/timeline/timelineModel.dart';
import 'package:bnl_task/services/utils/apiService.dart';
import 'package:bnl_task/utils/warna.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelinePage extends StatefulWidget {
  // String idmasalah;
  // TimelinePage({required this.idmasalah});
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
// ! Declare Variable HERE!
  ApiService _apiService = new ApiService();
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "", idmasalah = "";
  TextEditingController _tecNama = TextEditingController(text: "");
  TextEditingController _tecKeterangan = TextEditingController(text: "");

  List _itemsTimelineRequest = [];
  List _itemsTimelineProgress = [];
  List _itemsTimelinePenyelesaian = [];
  Future<void> tugasTimeline() async {
    final String response =
        await rootBundle.loadString('assets/json/timeline.json');
    final data = await json.decode(response);
    setState(() {
      _itemsTimelineRequest = data["request"];
    });
  }
  Future<void> progressTimeline() async {
    final String response =
        await rootBundle.loadString('assets/json/timeline.json');
    final data = await json.decode(response);
    setState(() {
      _itemsTimelineProgress = data["progress"];
    });
  }
  Future<void> penyelesaianTimeline() async {
    final String response =
        await rootBundle.loadString('assets/json/timeline.json');
    final data = await json.decode(response);
    setState(() {
      _itemsTimelinePenyelesaian = data["penyelesaian"];
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
  }

  @override
  initState() {
    // idmasalah = widget.idmasalah;
    super.initState();
    tugasTimeline();
    progressTimeline();
    penyelesaianTimeline();
    // cekToken();
  }

  @override
  dispose() {
    // TODO: implement dispose
    super.dispose();
    // _apiService.client.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Timeline '),
          centerTitle: true,
          backgroundColor: thirdcolor,
        ),
        body: SafeArea(
          child: Container(
            child: ListView.builder(
                itemCount: _itemsTimelineRequest.length,
                itemBuilder: (context, index) {
                  // print('hada ga ya? '+_itemsTimelineRequest[index]["keterangan"]);
                  return Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            child: TimelineTile(
                              alignment: TimelineAlign.manual,
                              lineXY: 0.05,
                              endChild: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                color: Colors.blue[300],
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Request',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Divider(
                                        thickness: 2,
                                        height: 8,
                                      ),
                                      Text('Keterangan : ' +
                                          _itemsTimelineRequest[index]
                                              ['keterangan']),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Kategori : ' +
                                                _itemsTimelineRequest[index]
                                                    ['kategori']),
                                          ],
                                        ),
                                      ),
                                      Text('tanggal : ' +_itemsTimelineRequest[index]['tanggal'],)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),  
                          Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            child: TimelineTile(
                              alignment: TimelineAlign.manual,
                              lineXY: 0.05,
                              endChild: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                color: Colors.orange[300],
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Progress',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Divider(
                                        thickness: 2,
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('tanggal : 2020-05-21'),
                                        ],
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Keterangan : Deadline untuk peresmian'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),   
                          Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            child: TimelineTile(
                              alignment: TimelineAlign.manual,
                              lineXY: 0.05,
                              endChild: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                color: Colors.green[300],
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Penyelesaian',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Divider(
                                        thickness: 2,
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('tanggal : 2020-05-21'),
                                        ],
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Keterangan : Deadline untuk peresmian'),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('User : Juned'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),            
                    ],
                  );
                }),
          ),
        ));
  }
  
  // ++ DESIGN LIST COMPONENT
  // Widget _listKomponen(List<TimelineModel>? dataIndex) {
  //   return ListView.builder(
  //       itemCount: dataIndex!.length,
  //       itemBuilder: (context, index) {
  //         TimelineModel? dataTimeline = dataIndex[index];
  //         return Padding(
  //             padding: const EdgeInsets.only(top: 10),
  //             child: Container(
  //               child: TimelineTile(
  //                   alignment: TimelineAlign.manual,
  //                   lineXY: 0.05,
  //                   endChild: _designItem(
  //                       dataTimeline.tipe,
  //                       dataTimeline.jam,
  //                       dataTimeline.tanggal,
  //                       dataTimeline.masalah,
  //                       dataTimeline.shift,
  //                       dataTimeline.perbaikan,
  //                       dataTimeline.engginer,
  //                       dataTimeline.tanggalprog,
  //                       dataTimeline.shiftprog.toString(),
  //                       dataTimeline.tanggalselesai,
  //                       dataTimeline.keteranganselesai,
  //                       dataTimeline.kode,
  //                       dataTimeline.barang,
  //                       dataTimeline.satuan,
  //                       dataTimeline.qty,
  //                       dataTimeline.keterangancheckout)),
  //             ));
  //       });
  // }

  // Widget _designItem(
  //     int tipe,
  //     String tanggal,
  //     String keterangan,
  //     String due_date,
  //     String kategori,
  //     String user,
  //     String waktuselesai,) {
  //   double c_width = MediaQuery.of(context).size.width * 0.8;
  //   if (tipe == 1) {
  //     // * show data masalah
  //     return Container(
  //       color: Colors.orange[300],
  //       child: Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Masalah Shift ' + shift,
  //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //               ),
  //               Divider(
  //                 thickness: 2,
  //                 height: 8,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text('Tanggal : '),
  //                   Text(tanggal),
  //                   Text(' ' + jam),
  //                 ],
  //               ),
  //               Expanded(
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text('Keterangan : '),
  //                     Text(masalah),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           )),
  //     );
  //   } else if (tipe == 2) {
  //     // * show data progress
  //     return Container(
  //       width: c_width,
  //       color: Colors.green[300],
  //       child: Padding(
  //         padding: const EdgeInsets.all(12.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Progress',
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //             ),
  //             Divider(
  //               thickness: 2,
  //               height: 8,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [Text('Engineer : '), Text(engginer)],
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text('Tanggal : '),
  //                 Text(tanggalprog),
  //               ],
  //             ),
  //             Flexible(
  //               child: Text('Keterangan : ' + perbaikan),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   } else if (tipe == 3) {
  //     // * show data penyelesaian
  //     return Container(
  //       color: Colors.blue[300],
  //       child: Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Penyelesaian',
  //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //               ),
  //               Divider(
  //                 thickness: 2,
  //                 height: 8,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text('Tanggal : '),
  //                   Text(tanggalselesai),
  //                 ],
  //               ),
  //               Flexible(
  //                 child: Text('Keterangan : ' + keteranganselesai),
  //               )
  //             ],
  //           )),
  //     );
  //   } else if (tipe == 4) {
  //     // * show data barang
  //     return Container(
  //       color: Colors.red[300],
  //       child: Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Barang',
  //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //               ),
  //               Divider(
  //                 thickness: 2,
  //                 height: 8,
  //               ),
  //               Flexible(
  //                 child: Text('Barang : (' + kode + ') ' + barang),
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text('Jumlah : '),
  //                   Text(qty),
  //                   Text(' ' + satuan),
  //                 ],
  //               ),
  //               Flexible(
  //                 child: Text('Keterangan : ' + keterangancheckout),
  //               )
  //             ],
  //           )),
  //     );
  //   } else {
  //     return Container();
  //   }
  // }
}
