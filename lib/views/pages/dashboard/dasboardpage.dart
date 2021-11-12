import 'dart:convert';
import 'dart:ui';
import 'package:bnl_task/services/models/dashboard/dashboardModel.dart';
import 'package:bnl_task/services/utils/apiService.dart';
import 'package:bnl_task/utils/ReusableClasses.dart';
import 'package:bnl_task/utils/warna.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // ! INITIALIZE VARIABLE
  ApiService _apiService = ApiService();
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "";
  var jml_masalah = "", jml_selesai = 0, belum_selesai = 0;
  List<DashboardModel> _dashboard = <DashboardModel>[];
  List _itemsTugas = [];
  List _itemsSelesai = [];
  List _itemsProgress = [];

  // * initial function for dummy tugas terbaru
  Future<void> tugasTerbaru() async {
    final String response =
        await rootBundle.loadString('assets/json/tugas.json');
    final data = await json.decode(response);
    setState(() {
      _itemsTugas = data["items"];
    });
  }

  // * initial function for dummy duedate
  Future<void> selesai() async {
    final String response =
        await rootBundle.loadString('assets/json/selesai.json');
    final data = await json.decode(response);
    setState(() {
      _itemsSelesai = data["items"];
    });
  }

  // * initial function for dummy duedate
  Future<void> progressterbaru() async {
    final String response =
        await rootBundle.loadString('assets/json/progress.json');
    final data = await json.decode(response);
    setState(() {
      _itemsProgress = data["items"];
    });
  }

  // * ceking token and getting dashboard value from api
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
      username = sp.getString("username");
      jabatan = sp.getString("jabatan");
    });
    _apiService.getDashboard(token!).then((value) {
      // DashboardModel dashboardModel = DashboardModel();
      print("Jumlah Masalah? " + value.toString());
      setState(() {
        _dashboard.addAll(value!);
      });
      // jml_masalah = value as String.toList();
      // jml_selesai = dashboardModel.jml_selesai;
      // belum_selesai = jml_masalah - jml_selesai;
    });
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    tugasTerbaru();
    progressterbaru();
    selesai();
    cekToken();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _apiService.client.close();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildTextHeader(screenHeight),
          // _buildBanner(screenHeight),
          _buildContent(screenHeight)
        ],
      ),
    );
  }

  // * code for design text header
  SliverToBoxAdapter _buildTextHeader(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 55, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'PT. BNL Patent',
                      style: TextStyle(fontSize: 12),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, Admin BNL',
                          // +
                          // username!.toUpperCase() +
                          // belum_selesai.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(GetSharedPreference().tokens)
                      ],
                    )
                  ],
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: CircleAvatar(
                // backgroundColor: primarycolor,
                backgroundColor: transparantcolor,
                child: Image.asset('assets/images/bnllauncher.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // * code for banner header
  SliverToBoxAdapter _buildBanner(double screenHeight) {
    return SliverToBoxAdapter(
        child: Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: thirdcolor,
          height: 150,
          width: 200,
          child: Image.asset('assets/images/bnllogo.png'),
        ),
      ),
    ));
  }

  Widget tasklistnew() {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Request",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 24.0),
          height: MediaQuery.of(context).size.height * 0.25,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _itemsTugas.length,
              itemBuilder: (context, index) {
                // print('datanya ada nggk ? $_items');
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    // color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _itemsTugas[index]["kategori"],
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                _itemsTugas[index]["tanggal"],
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey[400]),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            _itemsTugas[index]["keterangan"],
                            style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                  "Due. Date " + _itemsTugas[index]["due_date"],
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.grey[400])))
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget tugasProgress() {
    return Column(
      children: [
        // SizedBox(
        //   height: 30,
        // ),
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Progress",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          height: MediaQuery.of(context).size.height * 0.25,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _itemsProgress.length,
              itemBuilder: (context, index) {
                // print('datanya ada nggk ? $_items');
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    // color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 3,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "User : " + _itemsProgress[index]["user"],
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            _itemsProgress[index]["keterangan"],
                            style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                  "Tanggal " + _itemsProgress[index]["tanggal"],
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.grey[400])))
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget tugasSelesai() {
    return Column(
      children: [
        // SizedBox(
        //   height: 30,
        // ),
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Request Selesai",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          height: MediaQuery.of(context).size.height * 0.25,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _itemsSelesai.length,
              itemBuilder: (context, index) {
                // print('datanya ada nggk ? $_items');
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    // color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 3,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "User : " + _itemsSelesai[index]["user"],
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            _itemsSelesai[index]["keterangan"],
                            style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                  "Tanggal " + _itemsSelesai[index]["tanggal"],
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.grey[400])))
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  // * code for setting dashboard value api to ui
  SliverToBoxAdapter _buildContent(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
        ),
        child: _dashboard == []
            ? Text('Data Not Found')
            : Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 80,
                              // width: MediaQuery.of(context).size.width / 2.3,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Text(
                                    //     _dashboard
                                    //         .toString()
                                    //         .trim()
                                    //         .split('jml_masalah: ')[1]
                                    //         .split(',')[0],
                                    //     style: TextStyle(
                                    //         fontSize: 32,
                                    //         fontWeight: FontWeight.bold,
                                    //         color: Colors.blue)),
                                    Text('REQUEST SELESAI'),
                                    Text("20",
                                        style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green)),
                                  ]),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Container(
                              height: 85,
                              // width: MediaQuery.of(context).size.width / 2.3,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Text(
                                    //     _dashboard
                                    //         .toString()
                                    //         .trim()
                                    //         .split('jml_selesai: ')[1]
                                    //         .split(',')[0]
                                    //         .split(']')[0],
                                    //     style: TextStyle(
                                    //         fontSize: 32,
                                    //         fontWeight: FontWeight.bold,
                                    //         color: Colors.red)),
                                    Text('BELUM SELESAI'),
                                    Text("45",
                                        style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red)),
                                  ]),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[100],
                          thickness: 3,
                        ),
                        Container(
                          height: 85,
                          // width: MediaQuery.of(context).size.width / 2.3,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Text(
                                //     _dashboard
                                //         .toString()
                                //         .trim()
                                //         .split('jml_selesai: ')[1]
                                //         .split(',')[0]
                                //         .split(']')[0],
                                //     style: TextStyle(
                                //         fontSize: 32,
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.red)),
                                Text('JUMLAH REQUEST'),
                                Text("65",
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  tasklistnew(),
                  tugasProgress(),
                  tugasSelesai()
                ],
              ),
      ),
    );
    // return SliverToBoxAdapter(
    //   child: Container(
    //       padding: EdgeInsets.only(left: 20, right: 20),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Row(
    //             children: [Text('Jumlah Masalah'), Text('Jumlah Selesai')],
    //           )
    //         ],
    //       )),
    // );
  }
}
